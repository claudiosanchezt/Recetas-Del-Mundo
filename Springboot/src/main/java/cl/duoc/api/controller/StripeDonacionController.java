package cl.duoc.api.controller;

import cl.duoc.api.model.entities.Donacion;
import cl.duoc.api.model.repositories.DonacionRepository;
import cl.duoc.api.util.JwtUtil;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class StripeDonacionController {

    @Autowired
    private DonacionRepository donacionRepository;

    @Autowired
    private JwtUtil jwtUtil;

    // POST /donaciones/create-session
    @PostMapping("/donaciones/create-session")
    public ResponseEntity<?> createSession(@RequestHeader HttpHeaders headers, @RequestBody Map<String, Object> body) {
        try {
            String auth = headers.getFirst(HttpHeaders.AUTHORIZATION);
            if (auth == null || !auth.startsWith("Bearer ")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Authorization header missing or invalid");
            }
            String token = auth.substring(7);
            Integer tokenUserId;
            try {
                tokenUserId = jwtUtil.extractUserId(token);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
            }

            Integer idReceta = body.get("idReceta") == null ? null : (Integer) body.get("idReceta");
            Integer amount = body.get("amount") == null ? null : (Integer) body.get("amount");
            String currency = body.get("currency") == null ? "usd" : ((String) body.get("currency")).toLowerCase();

            if (amount == null || amount <= 0) {
                return ResponseEntity.badRequest().body("amount (in cents) is required and must be > 0");
            }

            // Create Donacion record with PENDING status
            Donacion d = new Donacion();
            d.setIdUsr(tokenUserId);
            d.setIdReceta(idReceta);
            d.setAmount(amount);
            d.setCurrency(currency.toUpperCase());
            d.setStatus("PENDING");
            Donacion saved = donacionRepository.save(d);

            // If STRIPE_SECRET_KEY is provided, create a real Checkout Session
            String stripeKey = System.getenv("STRIPE_SECRET_KEY");
            if (stripeKey == null || stripeKey.isEmpty()) {
                Map<String, Object> resp = new HashMap<>();
                resp.put("donacion", saved);
                resp.put("note", "STRIPE_SECRET_KEY not set; created local PENDING donacion. Set STRIPE_SECRET_KEY to create real sessions.");
                return ResponseEntity.status(HttpStatus.CREATED).body(resp);
            }

            Stripe.apiKey = stripeKey;

            SessionCreateParams.LineItem.PriceData.ProductData product = SessionCreateParams.LineItem.PriceData.ProductData.builder()
                    .setName("Donación Receta" + (idReceta != null ? (" #" + idReceta) : ""))
                    .build();

            SessionCreateParams.LineItem.PriceData priceData = SessionCreateParams.LineItem.PriceData.builder()
                    .setCurrency(currency)
                    .setUnitAmount(Long.valueOf(amount))
                    .setProductData(product)
                    .build();

            SessionCreateParams.LineItem item = SessionCreateParams.LineItem.builder()
                    .setPriceData(priceData)
                    .setQuantity(1L)
                    .build();

            String successUrl = System.getenv("DONATION_SUCCESS_URL");
            if (successUrl == null) successUrl = "https://example.com/success";
            String cancelUrl = System.getenv("DONATION_CANCEL_URL");
            if (cancelUrl == null) cancelUrl = "https://example.com/cancel";

            SessionCreateParams params = SessionCreateParams.builder()
                    .addPaymentMethodType(SessionCreateParams.PaymentMethodType.CARD)
                    .setMode(SessionCreateParams.Mode.PAYMENT)
                    .setSuccessUrl(successUrl + "?session_id={CHECKOUT_SESSION_ID}")
                    .setCancelUrl(cancelUrl)
                    .addLineItem(item)
                    .putMetadata("donacion_id", String.valueOf(saved.getIdDonacion()))
                    .build();

            Session session = Session.create(params);

            // Save session id on Donacion
            saved.setStripeSessionId(session.getId());
            donacionRepository.save(saved);

            Map<String, Object> result = new HashMap<>();
            result.put("sessionId", session.getId());
            result.put("url", session.getUrl());
            result.put("donacion", saved);

            return ResponseEntity.status(HttpStatus.CREATED).body(result);

        } catch (StripeException se) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Stripe error: " + se.getMessage());
        } catch (ClassCastException cce) {
            return ResponseEntity.badRequest().body("Invalid request payload types");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
}
