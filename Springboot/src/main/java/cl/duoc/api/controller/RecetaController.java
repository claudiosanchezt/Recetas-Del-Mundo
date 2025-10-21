package cl.duoc.api.controller;

import cl.duoc.api.model.entities.Receta;
import cl.duoc.api.model.entities.Usuario;
import cl.duoc.api.model.entities.Favorito;
import cl.duoc.api.model.entities.MeGusta;
import cl.duoc.api.model.entities.Estrella;
import cl.duoc.api.model.entities.Comentario;
import cl.duoc.api.model.entities.Ingrediente;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import cl.duoc.api.service.RecetaService;
import cl.duoc.api.service.RecetaDelDiaService;
import cl.duoc.api.service.FavoritoService;
import cl.duoc.api.service.MeGustaService;
import cl.duoc.api.service.EstrellaService;
import cl.duoc.api.service.ComentarioService;
import cl.duoc.api.util.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Collections;

@RestController
@RequestMapping("/recetas")
@CrossOrigin(origins = "*")
@Tag(name = "🍽️ Recetas", description = "API completa para gestión de recetas con ingredientes")
public class RecetaController {

    @Autowired
    private RecetaService recetaService;
    
    @Autowired
    private RecetaDelDiaService recetaDelDiaService;
    
    @Autowired
    private FavoritoService favoritoService;
    
    @Autowired
    private MeGustaService meGustaService;
    
    @Autowired
    private EstrellaService estrellaService;
    
    @Autowired
    private ComentarioService comentarioService;
    
    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private ObjectMapper objectMapper;

    // Helper method para extraer usuario ID del JWT token
    private Integer getUserIdFromToken(String authHeader) {
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            try {
                return jwtUtil.extractUserId(token);
            } catch (Exception e) {
                return null;
            }
        }
        return null;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> obtenerRecetas() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findAll();
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
            // Asegurar campo urlImagen para cada receta
            if (recetas != null) {
                for (Receta r : recetas) {
                    if (r.getUrlImagen() == null) {
                        r.setUrlImagen("");
                    }
                }
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener recetas: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> obtenerRecetaPorId(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> receta = recetaService.findById(id.intValue());
            
            if (receta.isPresent()) {
                response.put("exito", true);
                response.put("data", receta.get());
            } else {
                response.put("exito", false);
                response.put("mensaje", "Receta no encontrada");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al buscar receta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> crearReceta(@RequestBody Receta receta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Forzar que la fecha de creación la asigne el servidor
            receta.setFechaCreacion(java.time.LocalDate.now());
            
            // Asegurar que los ingredientes están correctamente relacionados
            if (receta.getIngredientes() != null) {
                for (cl.duoc.api.model.entities.Ingrediente ingrediente : receta.getIngredientes()) {
                    ingrediente.setReceta(receta);
                }
            }
            
            Receta nuevaReceta = recetaService.save(receta);
            response.put("exito", true);
            response.put("mensaje", "Receta creada correctamente con " + 
                       (nuevaReceta.getIngredientes() != null ? nuevaReceta.getIngredientes().size() : 0) + 
                       " ingredientes");
            response.put("data", nuevaReceta);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al crear receta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> actualizarReceta(@PathVariable Long id, @RequestBody Receta receta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> recetaExistente = recetaService.findById(id.intValue());
            
            if (recetaExistente.isPresent()) {
                Receta existing = recetaExistente.get();

                // Actualizar campos simples en la entidad persistente
                existing.setNombre(receta.getNombre() != null ? receta.getNombre() : existing.getNombre());
                existing.setUrlImagen(receta.getUrlImagen() != null ? receta.getUrlImagen() : existing.getUrlImagen());
                existing.setPreparacion(receta.getPreparacion() != null ? receta.getPreparacion() : existing.getPreparacion());
                existing.setIdCat(receta.getIdCat() != null ? receta.getIdCat() : existing.getIdCat());
                existing.setIdPais(receta.getIdPais() != null ? receta.getIdPais() : existing.getIdPais());
                existing.setEstado(receta.getEstado() != null ? receta.getEstado() : existing.getEstado());
                existing.setIdUsr(receta.getIdUsr() != null ? receta.getIdUsr() : existing.getIdUsr());
                // fechaCreacion: preservar siempre
                // Reasignar explícitamente la fecha de creación desde la entidad persistente para evitar confiar en el cliente
                existing.setFechaCreacion(existing.getFechaCreacion());

                // Manejo robusto de ingredientes: si el payload trae ingredientes, reemplazar la colección existente
                if (receta.getIngredientes() != null) {
                    // Limpiar la colección existente y añadir los nuevos, manteniendo la misma instancia
                    existing.getIngredientes().clear();
                    for (Ingrediente ingrediente : receta.getIngredientes()) {
                        ingrediente.setReceta(existing);
                        existing.getIngredientes().add(ingrediente);
                    }
                }

                Receta recetaActualizada = recetaService.save(existing);
                response.put("exito", true);
                response.put("mensaje", "Receta actualizada correctamente con " + 
                           (recetaActualizada.getIngredientes() != null ? recetaActualizada.getIngredientes().size() : 0) + 
                           " ingredientes");
                response.put("data", recetaActualizada);
            } else {
                response.put("exito", false);
                response.put("mensaje", "Receta no encontrada");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al actualizar receta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> eliminarReceta(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> receta = recetaService.findById(id.intValue());
            
            if (receta.isPresent()) {
                Receta recetaExistente = receta.get();
                recetaExistente.setEstado((short) 0);
                recetaService.save(recetaExistente);
                response.put("exito", true);
                response.put("mensaje", "Receta eliminada correctamente");
            } else {
                response.put("exito", false);
                response.put("mensaje", "Receta no encontrada");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al eliminar receta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/carrusel")
    public ResponseEntity<Map<String, Object>> obtenerRecetasCarrusel() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findTop8ByEstrellasMeGusta();
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
            response.put("mensaje", "Top 8 recetas mas valoradas para carrusel");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener recetas del carrusel: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/trending")
    public ResponseEntity<Map<String, Object>> obtenerRecetasTrending() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findTrendingRecetas();
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
            response.put("mensaje", "Recetas trending de los ultimos 30 dias");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener recetas trending: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/pais/{idPais}")
    public ResponseEntity<Map<String, Object>> obtenerRecetasPorPais(@PathVariable Integer idPais) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findByPaisId(idPais);
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
            response.put("mensaje", "Recetas del pais ID: " + idPais);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener recetas por pais: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/nombre/{nombre}")
    public ResponseEntity<Map<String, Object>> buscarRecetasPorNombre(@PathVariable String nombre) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findByNombreContaining(nombre);
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
            response.put("mensaje", "Recetas que contienen: '" + nombre + "'");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al buscar recetas por nombre: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/categoria/{idCategoria}")
    public ResponseEntity<Map<String, Object>> obtenerRecetasPorCategoria(@PathVariable Integer idCategoria) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findByCategoriaId(idCategoria);
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
            response.put("mensaje", "Recetas de la categoria ID: " + idCategoria);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener recetas por categoria: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}/ingredientes")
    public ResponseEntity<Map<String, Object>> obtenerIngredientesDeReceta(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Map<String, Object>> ingredientes = recetaService.findIngredientesByRecetaId(id.intValue());
            response.put("exito", true);
            response.put("data", ingredientes);
            response.put("total", ingredientes.size());
            response.put("recetaId", id);
            response.put("mensaje", "Ingredientes de la receta ID: " + id);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener ingredientes de la receta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/del-dia")
    public ResponseEntity<Map<String, Object>> obtenerRecetaDelDia() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> receta = recetaDelDiaService.getRecetaDelDia();
            
            if (receta.isPresent()) {
                response.put("exito", true);
                // Devolver como arreglo para mantener consistencia con otros endpoints
                response.put("data", Collections.singletonList(receta.get()));
                response.put("mensaje", "Receta del día obtenida desde base de datos");
                response.put("fecha", java.time.LocalDate.now().toString());
            } else {
                response.put("exito", false);
                response.put("mensaje", "No hay recetas disponibles para el día de hoy");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener receta del día: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<Map<String, Object>> obtenerRecetasPorUsuario(@PathVariable Integer usuarioId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Receta> recetas = recetaService.findByUsuarioId(usuarioId);
            response.put("exito", true);
            response.put("data", recetas);
            response.put("total", recetas.size());
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener recetas por usuario: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/ingredientes")
    public ResponseEntity<Map<String, Object>> agregarIngredientesAReceta(
            @PathVariable Long id,
            @RequestBody Object ingredientesPayload) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> recetaOpt = recetaService.findById(id.intValue());
            
            if (recetaOpt.isPresent()) {
                Receta receta = recetaOpt.get();
                // Normalizar payload: aceptar tanto array JSON como objeto único
                java.util.List<Ingrediente> ingredientes = new java.util.ArrayList<>();
                try {
                    if (ingredientesPayload instanceof java.util.List) {
                        CollectionType listType = objectMapper.getTypeFactory().constructCollectionType(java.util.ArrayList.class, Ingrediente.class);
                        ingredientes = objectMapper.convertValue(ingredientesPayload, listType);
                    } else {
                        Ingrediente single = objectMapper.convertValue(ingredientesPayload, Ingrediente.class);
                        if (single != null) ingredientes.add(single);
                    }
                } catch (Exception ex) {
                    response.put("exito", false);
                    response.put("mensaje", "Payload inválido para ingredientes: " + ex.getMessage());
                    return ResponseEntity.badRequest().body(response);
                }

                // Establecer la relación con la receta para cada ingrediente y añadir
                for (Ingrediente ingrediente : ingredientes) {
                    ingrediente.setReceta(receta);
                    receta.getIngredientes().add(ingrediente);
                }
                
                Receta recetaActualizada = recetaService.save(receta);
                response.put("exito", true);
                response.put("mensaje", "Ingredientes agregados correctamente");
                response.put("data", recetaActualizada.getIngredientes());
                response.put("total", recetaActualizada.getIngredientes().size());
            } else {
                response.put("exito", false);
                response.put("mensaje", "Receta no encontrada");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al agregar ingredientes: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{id}/ingredientes")
    public ResponseEntity<Map<String, Object>> actualizarIngredientesDeReceta(
            @PathVariable Long id,
            @RequestBody Object ingredientesPayload) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> recetaOpt = recetaService.findById(id.intValue());
            
            if (recetaOpt.isPresent()) {
                Receta receta = recetaOpt.get();
                // Normalizar payload: aceptar tanto array JSON como objeto único
                java.util.List<Ingrediente> ingredientes = new java.util.ArrayList<>();
                try {
                    if (ingredientesPayload instanceof java.util.List) {
                        CollectionType listType = objectMapper.getTypeFactory().constructCollectionType(java.util.ArrayList.class, Ingrediente.class);
                        ingredientes = objectMapper.convertValue(ingredientesPayload, listType);
                    } else {
                        Ingrediente single = objectMapper.convertValue(ingredientesPayload, Ingrediente.class);
                        if (single != null) ingredientes.add(single);
                    }
                } catch (Exception ex) {
                    response.put("exito", false);
                    response.put("mensaje", "Payload inválido para ingredientes: " + ex.getMessage());
                    return ResponseEntity.badRequest().body(response);
                }

                // Limpiar ingredientes existentes y añadir los nuevos
                receta.getIngredientes().clear();
                for (Ingrediente ingrediente : ingredientes) {
                    ingrediente.setReceta(receta);
                    receta.getIngredientes().add(ingrediente);
                }
                
                Receta recetaActualizada = recetaService.save(receta);
                response.put("exito", true);
                response.put("mensaje", "Ingredientes de la receta actualizados correctamente");
                response.put("data", recetaActualizada.getIngredientes());
                response.put("total", recetaActualizada.getIngredientes().size());
            } else {
                response.put("exito", false);
                response.put("mensaje", "Receta no encontrada");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al actualizar ingredientes: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{idReceta}/ingredientes/{idIngrediente}")
    public ResponseEntity<Map<String, Object>> eliminarIngredienteDeReceta(
            @PathVariable Long idReceta, 
            @PathVariable Long idIngrediente) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Receta> recetaOpt = recetaService.findById(idReceta.intValue());
            
            if (recetaOpt.isPresent()) {
                Receta receta = recetaOpt.get();
                
                // Buscar y eliminar el ingrediente específico
                boolean eliminado = receta.getIngredientes().removeIf(
                    ingrediente -> ingrediente.getIdIngrediente().equals(idIngrediente.intValue())
                );
                
                if (eliminado) {
                    Receta recetaActualizada = recetaService.save(receta);
                    response.put("exito", true);
                    response.put("mensaje", "Ingrediente eliminado correctamente de la receta");
                    response.put("ingredientesRestantes", recetaActualizada.getIngredientes().size());
                } else {
                    response.put("exito", false);
                    response.put("mensaje", "Ingrediente no encontrado en la receta");
                }
            } else {
                response.put("exito", false);
                response.put("mensaje", "Receta no encontrada");
            }
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al eliminar ingrediente: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // ========== ENDPOINTS DE FAVORITOS ==========
    
    @GetMapping("/favoritos")
    @Operation(summary = "Obtener favoritos del usuario autenticado", description = "Retorna las recetas favoritas del usuario autenticado mediante JWT")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Favoritos obtenidos exitosamente"),
        @ApiResponse(responseCode = "401", description = "Usuario no autenticado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> obtenerFavoritos(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer idUsuario = getUserIdFromToken(authHeader);
            List<Favorito> favoritos;
            
            if (idUsuario != null) {
                favoritos = favoritoService.getFavoritosByUsuario(idUsuario);
            } else {
                favoritos = favoritoService.getAllFavoritos();
            }
            response.put("exito", true);
            response.put("data", favoritos);
            response.put("total", favoritos.size());
            response.put("mensaje", "Favoritos obtenidos correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener favoritos: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/favoritos")
    @Operation(summary = "Agregar a favoritos", description = "Agrega una receta a favoritos del usuario")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Agregado a favoritos exitosamente"),
        @ApiResponse(responseCode = "400", description = "Ya existe en favoritos"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> agregarFavorito(
            @RequestParam Integer idUsuario, 
            @RequestParam Integer idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Crear favorito usando el servicio existente
            Favorito favorito = new Favorito();
            favorito.setUsuario(new Usuario(idUsuario));
            favorito.setReceta(new Receta(idReceta));
            favorito = favoritoService.save(favorito);
            response.put("exito", true);
            response.put("mensaje", "Receta agregada a favoritos");
            response.put("data", favorito);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al agregar favorito: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/favoritos")
    @Operation(summary = "Quitar de favoritos", description = "Remueve una receta de favoritos del usuario")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Removido de favoritos exitosamente"),
        @ApiResponse(responseCode = "404", description = "Favorito no encontrado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> quitarFavorito(
            @RequestParam Integer idUsuario, 
            @RequestParam Integer idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            favoritoService.deleteByRecetaAndUsuario(idReceta, idUsuario);
            response.put("exito", true);
            response.put("mensaje", "Receta removida de favoritos");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al quitar favorito: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/favoritos/count/{idReceta}")
    @Operation(summary = "Contar favoritos de receta", description = "Obtiene el número total de favoritos de una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Conteo obtenido exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> contarFavoritos(
            @Parameter(description = "ID de la receta", required = true) @PathVariable Long idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Long count = favoritoService.countByReceta(idReceta.intValue());
            response.put("exito", true);
            response.put("count", count);
            response.put("mensaje", "Conteo de favoritos obtenido");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al contar favoritos: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // ========== ENDPOINTS DE ME GUSTA ==========
    
    @GetMapping("/megusta")
    @Operation(summary = "Obtener me gusta del usuario autenticado", description = "Retorna las recetas que le gustan al usuario autenticado mediante JWT")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Me gusta obtenidos exitosamente"),
        @ApiResponse(responseCode = "401", description = "Usuario no autenticado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> obtenerMeGusta(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer idUsuario = getUserIdFromToken(authHeader);
            List<MeGusta> meGustas;
            
            if (idUsuario != null) {
                meGustas = meGustaService.getMeGustasByUsuario(idUsuario);
            } else {
                meGustas = meGustaService.getAllMeGusta();
            }
            response.put("exito", true);
            response.put("data", meGustas);
            response.put("total", meGustas.size());
            response.put("mensaje", "Me gusta obtenidos correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener me gusta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/megusta")
    @Operation(summary = "Dar me gusta", description = "Agrega un me gusta a una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Me gusta agregado exitosamente"),
        @ApiResponse(responseCode = "400", description = "Ya tiene me gusta"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> darMeGusta(
            @RequestParam Integer idUsuario, 
            @RequestParam Integer idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Crear meGusta usando el servicio existente
            MeGusta meGusta = new MeGusta();
            meGusta.setUsuario(new Usuario(idUsuario));
            meGusta.setReceta(new Receta(idReceta));
            meGusta = meGustaService.save(meGusta);
            response.put("exito", true);
            response.put("mensaje", "Me gusta agregado");
            response.put("data", meGusta);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al dar me gusta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/megusta")
    @Operation(summary = "Quitar me gusta", description = "Remueve un me gusta de una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Me gusta removido exitosamente"),
        @ApiResponse(responseCode = "404", description = "Me gusta no encontrado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> quitarMeGusta(
            @RequestParam Integer idUsuario, 
            @RequestParam Integer idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            meGustaService.deleteByRecetaAndUsuario(idReceta, idUsuario);
            response.put("exito", true);
            response.put("mensaje", "Me gusta removido");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al quitar me gusta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/megustas/count/{idReceta}")
    @Operation(summary = "Contar me gusta de receta", description = "Obtiene el número total de me gusta de una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Conteo obtenido exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> contarMeGustas(
            @Parameter(description = "ID de la receta", required = true) @PathVariable Long idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Long count = meGustaService.countByReceta(idReceta.intValue());
            response.put("exito", true);
            response.put("count", count);
            response.put("mensaje", "Conteo de me gusta obtenido");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al contar me gusta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // ========== ENDPOINTS DE ESTRELLAS ==========
    
    @GetMapping("/estrellas")
    @Operation(summary = "Obtener calificaciones del usuario autenticado", description = "Retorna las calificaciones (estrellas) dadas por el usuario autenticado mediante JWT")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Calificaciones obtenidas exitosamente"),
        @ApiResponse(responseCode = "401", description = "Usuario no autenticado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> obtenerEstrellas(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer idUsuario = getUserIdFromToken(authHeader);
            List<Estrella> estrellas;
            
            if (idUsuario != null) {
                estrellas = estrellaService.getEstrellasByUsuario(idUsuario);
            } else {
                estrellas = estrellaService.getAllEstrellas();
            }
            response.put("exito", true);
            response.put("data", estrellas);
            response.put("total", estrellas.size());
            response.put("mensaje", "Calificaciones obtenidas correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener calificaciones: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/estrellas")
    @Operation(summary = "Calificar receta", description = "Agrega o actualiza la calificación (1-5 estrellas) de una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Calificación agregada exitosamente"),
        @ApiResponse(responseCode = "400", description = "Valor de estrellas inválido"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> calificarReceta(
            @RequestParam Integer idUsuario, 
            @RequestParam Integer idReceta,
            @RequestParam Short estrellas) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (estrellas < 1 || estrellas > 5) {
                response.put("exito", false);
                response.put("mensaje", "Las estrellas deben ser entre 1 y 5");
                return ResponseEntity.ok(response);
            }
            
            // Crear y guardar estrella usando servicio real
            Estrella estrella = new Estrella();
            estrella.setUsuario(new Usuario(idUsuario));
            estrella.setReceta(new Receta(idReceta));
            estrella.setValor(estrellas);
            estrella = estrellaService.save(estrella);
            response.put("exito", true);
            response.put("mensaje", "Calificación registrada");
            response.put("data", estrella);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al calificar receta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/estrellas/stats/{idReceta}")
    @Operation(summary = "Estadísticas de calificación", description = "Obtiene el promedio y total de calificaciones de una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Estadísticas obtenidas exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> obtenerEstadisticasEstrellas(
            @Parameter(description = "ID de la receta", required = true) @PathVariable Long idReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Usar servicios reales para estadísticas
            Map<String, Object> stats = new HashMap<>();
            Double promedio = estrellaService.avgByReceta(idReceta.intValue());
            Long total = estrellaService.countByReceta(idReceta.intValue());
            stats.put("promedio", promedio != null ? promedio : 0.0);
            stats.put("total", total != null ? total : 0);
            response.put("exito", true);
            response.put("data", stats);
            response.put("mensaje", "Estadísticas obtenidas correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener estadísticas: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // ========== ENDPOINTS DE COMENTARIOS ==========
    
    @GetMapping("/comentarios")
    @Operation(summary = "Obtener comentarios", description = "Retorna los comentarios de un usuario o todos los comentarios")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Comentarios obtenidos exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> obtenerComentarios(@RequestParam(required = false) Integer idUsuario) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Comentario> comentarios;
            if (idUsuario != null) {
                // Obtener comentarios por usuario (método a implementar)
                comentarios = comentarioService.getComentariosByUsuario(idUsuario);
            } else {
                // Obtener todos los comentarios (método a implementar)
                comentarios = comentarioService.getAllComentarios();
            }
            
            response.put("exito", true);
            // sanitize comentarios: only include idComentario, texto, fechaCreacion, receta{idReceta,idUsr}, usuario{idUsr}
            java.util.List<java.util.Map<String,Object>> out = new java.util.ArrayList<>();
            for (Comentario c : comentarios) {
                java.util.Map<String,Object> m = new java.util.HashMap<>();
                m.put("idComentario", c.getIdComentario());
                m.put("texto", c.getTexto());
                m.put("fechaCreacion", c.getFechaCreacion());
                java.util.Map<String,Object> r = new java.util.HashMap<>();
                if (c.getReceta() != null) { r.put("idReceta", c.getReceta().getIdReceta()); r.put("idUsr", c.getReceta().getIdUsr()); }
                m.put("receta", r);
                java.util.Map<String,Object> u = new java.util.HashMap<>();
                if (c.getUsuario() != null) { u.put("idUsr", c.getUsuario().getIdUsr()); }
                m.put("usuario", u);
            
                out.add(m);
            }
            response.put("data", out);
            response.put("total", comentarios.size());
            response.put("mensaje", "Comentarios obtenidos correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener comentarios: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/comentarios/receta/{id}")
    @Operation(summary = "Obtener comentarios de receta", description = "Retorna todos los comentarios de una receta específica")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Comentarios obtenidos exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> obtenerComentariosPorReceta(
            @Parameter(description = "ID de la receta", required = true) @PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Usar servicio real
            List<Comentario> comentarios = comentarioService.getComentariosByReceta(id.intValue());
            response.put("exito", true);
            java.util.List<java.util.Map<String,Object>> out = new java.util.ArrayList<>();
            for (Comentario c : comentarios) {
                java.util.Map<String,Object> m = new java.util.HashMap<>();
                m.put("idComentario", c.getIdComentario());
                m.put("texto", c.getTexto());
                m.put("fechaCreacion", c.getFechaCreacion());
                java.util.Map<String,Object> r = new java.util.HashMap<>();
                if (c.getReceta() != null) { r.put("idReceta", c.getReceta().getIdReceta()); r.put("idUsr", c.getReceta().getIdUsr()); }
                m.put("receta", r);
                java.util.Map<String,Object> u = new java.util.HashMap<>();
                if (c.getUsuario() != null) { u.put("idUsr", c.getUsuario().getIdUsr()); }
                m.put("usuario", u);
                out.add(m);
            }
            response.put("data", out);
            response.put("total", comentarios.size());
            response.put("mensaje", "Comentarios de la receta obtenidos correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al obtener comentarios: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/comentarios")
    @Operation(summary = "Agregar comentario", description = "Agrega un nuevo comentario a una receta")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Comentario agregado exitosamente"),
        @ApiResponse(responseCode = "400", description = "Datos inválidos"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> agregarComentario(
            @RequestParam Integer idUsuario, 
            @RequestParam Integer idReceta,
            @RequestParam String texto) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (texto == null || texto.trim().isEmpty()) {
                response.put("exito", false);
                response.put("mensaje", "El texto del comentario no puede estar vacío");
                return ResponseEntity.ok(response);
            }
            
            // Crear comentario básico por ahora
            Comentario comentario = new Comentario();
            comentario.setUsuario(new Usuario(idUsuario));
            comentario.setReceta(new Receta(idReceta));
            comentario.setTexto(texto.trim());
            response.put("exito", true);
            // Usar servicio real
            comentario = comentarioService.save(comentario);
            response.put("exito", true);
            response.put("mensaje", "Comentario agregado correctamente");
            // sanitize comentario for response
            java.util.Map<String,Object> m = new java.util.HashMap<>();
            m.put("idComentario", comentario.getIdComentario());
            m.put("texto", comentario.getTexto());
            m.put("fechaCreacion", comentario.getFechaCreacion());
            java.util.Map<String,Object> r = new java.util.HashMap<>();
            if (comentario.getReceta() != null) { r.put("idReceta", comentario.getReceta().getIdReceta()); r.put("idUsr", comentario.getReceta().getIdUsr()); }
            m.put("receta", r);
            java.util.Map<String,Object> u = new java.util.HashMap<>();
            if (comentario.getUsuario() != null) { u.put("idUsr", comentario.getUsuario().getIdUsr()); }
            m.put("usuario", u);
            response.put("data", m);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al agregar comentario: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // ========== OPERACIONES CRUD ADICIONALES ==========

    // UPDATE - Actualizar comentario
    @PutMapping("/comentarios/{id}")
    @Operation(summary = "Actualizar comentario", description = "Actualiza el texto de un comentario existente")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Comentario actualizado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Comentario no encontrado"),
        @ApiResponse(responseCode = "400", description = "Datos inválidos"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> actualizarComentario(
            @Parameter(description = "ID del comentario", required = true) @PathVariable Integer id,
            @RequestParam(required = false) String texto,
            @RequestBody(required = false) Map<String,Object> body) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Comentario> comentarioOpt = comentarioService.getComentarioById(id);
            if (!comentarioOpt.isPresent()) {
                response.put("exito", false);
                response.put("mensaje", "Comentario no encontrado con ID: " + id);
                return ResponseEntity.ok(response);
            }
            
            // texto puede venir por query param o por body JSON { "texto": "..." }
            String effectiveTexto = texto;
            if ((effectiveTexto == null || effectiveTexto.trim().isEmpty()) && body != null && body.get("texto") != null) {
                effectiveTexto = String.valueOf(body.get("texto"));
            }
            if (effectiveTexto == null || effectiveTexto.trim().isEmpty()) {
                response.put("exito", false);
                response.put("mensaje", "El texto del comentario no puede estar vacío");
                return ResponseEntity.ok(response);
            }

            Comentario comentario = comentarioOpt.get();
            comentario.setTexto(effectiveTexto.trim());
            comentario = comentarioService.save(comentario);
            
            response.put("exito", true);
            response.put("mensaje", "Comentario actualizado correctamente");
            // sanitize updated comentario
            java.util.Map<String,Object> m = new java.util.HashMap<>();
            m.put("idComentario", comentario.getIdComentario());
            m.put("texto", comentario.getTexto());
            m.put("fechaCreacion", comentario.getFechaCreacion());
            java.util.Map<String,Object> r = new java.util.HashMap<>();
            if (comentario.getReceta() != null) { r.put("idReceta", comentario.getReceta().getIdReceta()); r.put("idUsr", comentario.getReceta().getIdUsr()); }
            m.put("receta", r);
            java.util.Map<String,Object> u = new java.util.HashMap<>();
            if (comentario.getUsuario() != null) { u.put("idUsr", comentario.getUsuario().getIdUsr()); }
            m.put("usuario", u);
            response.put("data", m);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al actualizar comentario: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // DELETE - Eliminar comentario
    @DeleteMapping("/comentarios/{id}")
    @Operation(summary = "Eliminar comentario", description = "Elimina un comentario por su ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Comentario eliminado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Comentario no encontrado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> eliminarComentario(
            @Parameter(description = "ID del comentario", required = true) @PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Comentario> comentario = comentarioService.getComentarioById(id);
            if (!comentario.isPresent()) {
                response.put("exito", false);
                response.put("mensaje", "Comentario no encontrado con ID: " + id);
                return ResponseEntity.ok(response);
            }
            
            comentarioService.delete(id);
            response.put("exito", true);
            response.put("mensaje", "Comentario eliminado correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al eliminar comentario: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // UPDATE - Actualizar calificación de estrella
    @PutMapping("/estrellas/{id}")
    @Operation(summary = "Actualizar calificación", description = "Actualiza la calificación (estrellas) existente")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Calificación actualizada exitosamente"),
        @ApiResponse(responseCode = "404", description = "Calificación no encontrada"),
        @ApiResponse(responseCode = "400", description = "Valor de estrellas inválido"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> actualizarEstrella(
            @Parameter(description = "ID de la calificación", required = true) @PathVariable Integer id,
            @RequestParam Short estrellas) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (estrellas < 1 || estrellas > 5) {
                response.put("exito", false);
                response.put("mensaje", "Las estrellas deben ser entre 1 y 5");
                return ResponseEntity.ok(response);
            }
            
            Optional<Estrella> estrellaOpt = estrellaService.getEstrellaById(id);
            if (!estrellaOpt.isPresent()) {
                response.put("exito", false);
                response.put("mensaje", "Calificación no encontrada con ID: " + id);
                return ResponseEntity.ok(response);
            }
            
            Estrella estrella = estrellaOpt.get();
            estrella.setValor(estrellas);
            estrella = estrellaService.save(estrella);
            
            response.put("exito", true);
            response.put("mensaje", "Calificación actualizada correctamente");
            response.put("data", estrella);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al actualizar calificación: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // DELETE - Eliminar calificación de estrella
    @DeleteMapping("/estrellas/{id}")
    @Operation(summary = "Eliminar calificación", description = "Elimina una calificación (estrella) por su ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Calificación eliminada exitosamente"),
        @ApiResponse(responseCode = "404", description = "Calificación no encontrada"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> eliminarEstrella(
            @Parameter(description = "ID de la calificación", required = true) @PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Estrella> estrella = estrellaService.getEstrellaById(id);
            if (!estrella.isPresent()) {
                response.put("exito", false);
                response.put("mensaje", "Calificación no encontrada con ID: " + id);
                return ResponseEntity.ok(response);
            }
            
            estrellaService.delete(id);
            response.put("exito", true);
            response.put("mensaje", "Calificación eliminada correctamente");
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al eliminar calificación: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // UPDATE - Actualizar favorito (cambiar receta favorita)
    @PutMapping("/favoritos/{id}")
    @Operation(summary = "Actualizar favorito", description = "Actualiza la receta de un favorito existente")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Favorito actualizado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Favorito no encontrado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> actualizarFavorito(
            @Parameter(description = "ID del favorito", required = true) @PathVariable Integer id,
            @RequestParam Integer nuevaIdReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<Favorito> favoritoOpt = favoritoService.getFavoritoById(id);
            if (!favoritoOpt.isPresent()) {
                response.put("exito", false);
                response.put("mensaje", "Favorito no encontrado con ID: " + id);
                return ResponseEntity.ok(response);
            }
            
            Favorito favorito = favoritoOpt.get();
            favorito.setReceta(new Receta(nuevaIdReceta));
            favorito = favoritoService.save(favorito);
            
            response.put("exito", true);
            response.put("mensaje", "Favorito actualizado correctamente");
            response.put("data", favorito);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al actualizar favorito: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    // UPDATE - Actualizar me gusta
    @PutMapping("/megusta/{id}")
    @Operation(summary = "Actualizar me gusta", description = "Actualiza la receta de un me gusta existente")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Me gusta actualizado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Me gusta no encontrado"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public ResponseEntity<Map<String, Object>> actualizarMeGusta(
            @Parameter(description = "ID del me gusta", required = true) @PathVariable Integer id,
            @RequestParam Integer nuevaIdReceta) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<MeGusta> meGustaOpt = meGustaService.getMeGustaById(id);
            if (!meGustaOpt.isPresent()) {
                response.put("exito", false);
                response.put("mensaje", "Me gusta no encontrado con ID: " + id);
                return ResponseEntity.ok(response);
            }
            
            MeGusta meGusta = meGustaOpt.get();
            meGusta.setReceta(new Receta(nuevaIdReceta));
            meGusta = meGustaService.save(meGusta);
            
            response.put("exito", true);
            response.put("mensaje", "Me gusta actualizado correctamente");
            response.put("data", meGusta);
        } catch (Exception e) {
            response.put("exito", false);
            response.put("mensaje", "Error al actualizar me gusta: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
}
