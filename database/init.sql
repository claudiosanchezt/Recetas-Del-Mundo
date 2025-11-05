--
-- PostgreSQL database dump
--

\restrict XghASFgRMcEdaNuqEDlzZXmwfbYaG8ra1diyv3BZcmf9T4sUOrVx8k5PogAyvUy

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_id_perfil_fk;
ALTER TABLE IF EXISTS ONLY public.receta DROP CONSTRAINT IF EXISTS receta_id_usr_fkey;
ALTER TABLE IF EXISTS ONLY public.receta DROP CONSTRAINT IF EXISTS receta_id_pais_fkey;
ALTER TABLE IF EXISTS ONLY public.receta DROP CONSTRAINT IF EXISTS receta_id_cat_fkey;
ALTER TABLE IF EXISTS ONLY public.pais DROP CONSTRAINT IF EXISTS pais_id_usr_fkey;
ALTER TABLE IF EXISTS ONLY public.estrella DROP CONSTRAINT IF EXISTS fkrxcbprpobmiqkdxmoo32ylkld;
ALTER TABLE IF EXISTS ONLY public.favorito DROP CONSTRAINT IF EXISTS fkrq0y1oifowf2v3iu8mtqqidvs;
ALTER TABLE IF EXISTS ONLY public.me_gusta DROP CONSTRAINT IF EXISTS fklt9disbee9m0fbsu33vxh7qdy;
ALTER TABLE IF EXISTS ONLY public.favorito DROP CONSTRAINT IF EXISTS fkh7xyncd05syjb4qbrc87i0da2;
ALTER TABLE IF EXISTS ONLY public.estrella DROP CONSTRAINT IF EXISTS fkfey8w00kt60dhi2c4i96dj4b2;
ALTER TABLE IF EXISTS ONLY public.me_gusta DROP CONSTRAINT IF EXISTS fkeu6k9bc9cdoikmwh3xc81oy48;
ALTER TABLE IF EXISTS ONLY public.sesion_pago DROP CONSTRAINT IF EXISTS fk_sesion_pago_donacion;
ALTER TABLE IF EXISTS ONLY public.ingrediente DROP CONSTRAINT IF EXISTS fk_ingrediente_receta;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS donacion_id_usr_fk;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS donacion_id_receta_fk;
ALTER TABLE IF EXISTS ONLY public.comentario DROP CONSTRAINT IF EXISTS comentario_usuario_fkey;
ALTER TABLE IF EXISTS ONLY public.comentario DROP CONSTRAINT IF EXISTS comentario_receta_fkey;
ALTER TABLE IF EXISTS ONLY public.categoria DROP CONSTRAINT IF EXISTS categoria_id_usr_fkey;
DROP TRIGGER IF EXISTS set_fecha_actualizacion ON public.sesion_pago;
DROP INDEX IF EXISTS public.ux_usuario_email;
DROP INDEX IF EXISTS public.ux_sesion_pago_sessionid;
DROP INDEX IF EXISTS public.ux_favorito_usr_receta;
DROP INDEX IF EXISTS public.ingrediente_nombre_key;
DROP INDEX IF EXISTS public.idx_receta_id_usr;
DROP INDEX IF EXISTS public.idx_receta_id_pais;
DROP INDEX IF EXISTS public.idx_receta_id_cat;
DROP INDEX IF EXISTS public.idx_ingrediente_id_receta;
DROP INDEX IF EXISTS public.idx_comentario_id_receta;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_email_key;
ALTER TABLE IF EXISTS ONLY public.me_gusta DROP CONSTRAINT IF EXISTS uq_megusta_receta_usuario;
ALTER TABLE IF EXISTS ONLY public.perfil DROP CONSTRAINT IF EXISTS uk_3b0dloqo94v7r6tjahpid9hc3;
ALTER TABLE IF EXISTS ONLY public.favorito DROP CONSTRAINT IF EXISTS uk887bu4uo8aawt4vqxaf9tgpxu;
ALTER TABLE IF EXISTS ONLY public.sesion_pago DROP CONSTRAINT IF EXISTS sesion_pago_pkey;
ALTER TABLE IF EXISTS ONLY public.receta DROP CONSTRAINT IF EXISTS receta_pkey;
ALTER TABLE IF EXISTS ONLY public.receta DROP CONSTRAINT IF EXISTS receta_nombre_key;
ALTER TABLE IF EXISTS ONLY public.receta_del_dia DROP CONSTRAINT IF EXISTS receta_del_dia_pkey;
ALTER TABLE IF EXISTS ONLY public.perfil DROP CONSTRAINT IF EXISTS perfil_pkey;
ALTER TABLE IF EXISTS ONLY public.pais DROP CONSTRAINT IF EXISTS pais_pkey;
ALTER TABLE IF EXISTS ONLY public.pais DROP CONSTRAINT IF EXISTS pais_nombre_key;
ALTER TABLE IF EXISTS ONLY public.me_gusta DROP CONSTRAINT IF EXISTS me_gusta_pkey;
ALTER TABLE IF EXISTS ONLY public.ingrediente DROP CONSTRAINT IF EXISTS ingrediente_new_pkey;
ALTER TABLE IF EXISTS ONLY public.favorito DROP CONSTRAINT IF EXISTS favorito_pkey;
ALTER TABLE IF EXISTS ONLY public.estrella DROP CONSTRAINT IF EXISTS estrella_pkey;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS donacion_pkey;
ALTER TABLE IF EXISTS ONLY public.comentario DROP CONSTRAINT IF EXISTS comentario_pkey;
ALTER TABLE IF EXISTS ONLY public.categoria DROP CONSTRAINT IF EXISTS categoria_pkey;
ALTER TABLE IF EXISTS ONLY public.categoria DROP CONSTRAINT IF EXISTS categoria_nombre_key;
ALTER TABLE IF EXISTS public.usuario ALTER COLUMN id_usr DROP DEFAULT;
ALTER TABLE IF EXISTS public.sesion_pago ALTER COLUMN id_sesion DROP DEFAULT;
ALTER TABLE IF EXISTS public.receta ALTER COLUMN id_receta DROP DEFAULT;
ALTER TABLE IF EXISTS public.perfil ALTER COLUMN id_perfil DROP DEFAULT;
ALTER TABLE IF EXISTS public.pais ALTER COLUMN id_pais DROP DEFAULT;
ALTER TABLE IF EXISTS public.me_gusta ALTER COLUMN id_megusta DROP DEFAULT;
ALTER TABLE IF EXISTS public.ingrediente ALTER COLUMN id_ingrediente DROP DEFAULT;
ALTER TABLE IF EXISTS public.favorito ALTER COLUMN id_fav DROP DEFAULT;
ALTER TABLE IF EXISTS public.estrella ALTER COLUMN id_estrella DROP DEFAULT;
ALTER TABLE IF EXISTS public.donacion ALTER COLUMN id_donacion DROP DEFAULT;
ALTER TABLE IF EXISTS public.categoria ALTER COLUMN id_cat DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.usuario_id_usr_seq;
DROP TABLE IF EXISTS public.usuario;
DROP SEQUENCE IF EXISTS public.sesion_pago_id_sesion_seq;
DROP TABLE IF EXISTS public.sesion_pago;
DROP SEQUENCE IF EXISTS public.receta_id_receta_seq;
DROP TABLE IF EXISTS public.receta_del_dia;
DROP TABLE IF EXISTS public.receta;
DROP SEQUENCE IF EXISTS public.perfil_id_perfil_seq;
DROP TABLE IF EXISTS public.perfil;
DROP SEQUENCE IF EXISTS public.pais_id_pais_seq;
DROP TABLE IF EXISTS public.pais;
DROP SEQUENCE IF EXISTS public.me_gusta_id_megusta_seq;
DROP TABLE IF EXISTS public.me_gusta;
DROP SEQUENCE IF EXISTS public.ingrediente_new_id_ingrediente_seq;
DROP TABLE IF EXISTS public.ingrediente;
DROP SEQUENCE IF EXISTS public.favorito_id_fav_seq;
DROP TABLE IF EXISTS public.favorito;
DROP SEQUENCE IF EXISTS public.estrella_id_estrella_seq;
DROP TABLE IF EXISTS public.estrella;
DROP SEQUENCE IF EXISTS public.donacion_id_donacion_seq;
DROP TABLE IF EXISTS public.donacion;
DROP TABLE IF EXISTS public.comentario;
DROP SEQUENCE IF EXISTS public.comentario_id_comentario_seq;
DROP SEQUENCE IF EXISTS public.categoria_id_cat_seq;
DROP TABLE IF EXISTS public.categoria;
DROP FUNCTION IF EXISTS public.trg_update_fecha_actualizacion();
DROP FUNCTION IF EXISTS public._pick_image(id_in bigint);
DROP EXTENSION IF EXISTS pgcrypto;
--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: _pick_image(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._pick_image(id_in bigint) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT url FROM _pool_imagenes ORDER BY idx LIMIT 1 OFFSET ((id_in - 1) % (SELECT count(*) FROM _pool_imagenes));
$$;


--
-- Name: trg_update_fecha_actualizacion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trg_update_fecha_actualizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.fecha_actualizacion = now();
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria (
    id_cat integer NOT NULL,
    nombre character varying(100) NOT NULL,
    url_imagen character varying(500),
    estado smallint DEFAULT 1 NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now() NOT NULL,
    comentario character varying(500),
    id_usr integer
);


--
-- Name: categoria_id_cat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categoria_id_cat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categoria_id_cat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categoria_id_cat_seq OWNED BY public.categoria.id_cat;


--
-- Name: comentario_id_comentario_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comentario_id_comentario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comentario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comentario (
    id_comentario integer DEFAULT nextval('public.comentario_id_comentario_seq'::regclass) NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now() NOT NULL,
    id_receta integer NOT NULL,
    texto character varying(255),
    id_usr integer
);


--
-- Name: donacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donacion (
    id_donacion integer NOT NULL,
    amount integer,
    currency character varying(255),
    fecha_actualizacion timestamp(6) without time zone,
    fecha_creacion timestamp(6) without time zone DEFAULT now(),
    id_receta integer,
    id_usr integer,
    status character varying(255),
    stripe_payment_intent character varying(255),
    stripe_session_id character varying(255)
);


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donacion_id_donacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donacion_id_donacion_seq OWNED BY public.donacion.id_donacion;


--
-- Name: estrella; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estrella (
    id_estrella integer NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now(),
    valor smallint NOT NULL,
    id_receta integer NOT NULL,
    id_usr integer NOT NULL
);


--
-- Name: estrella_id_estrella_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estrella_id_estrella_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estrella_id_estrella_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estrella_id_estrella_seq OWNED BY public.estrella.id_estrella;


--
-- Name: favorito; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorito (
    id_fav integer NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now() NOT NULL,
    id_receta integer NOT NULL,
    id_usr integer NOT NULL
);


--
-- Name: favorito_id_fav_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorito_id_fav_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorito_id_fav_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorito_id_fav_seq OWNED BY public.favorito.id_fav;


--
-- Name: ingrediente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingrediente (
    id_ingrediente integer NOT NULL,
    nombre text NOT NULL,
    id_receta integer NOT NULL
);


--
-- Name: ingrediente_new_id_ingrediente_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ingrediente_new_id_ingrediente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingrediente_new_id_ingrediente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ingrediente_new_id_ingrediente_seq OWNED BY public.ingrediente.id_ingrediente;


--
-- Name: me_gusta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.me_gusta (
    id_megusta integer NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now(),
    id_receta integer NOT NULL,
    id_usr integer NOT NULL
);


--
-- Name: me_gusta_id_megusta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.me_gusta_id_megusta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: me_gusta_id_megusta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.me_gusta_id_megusta_seq OWNED BY public.me_gusta.id_megusta;


--
-- Name: pais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pais (
    id_pais integer NOT NULL,
    nombre character varying(100) NOT NULL,
    url_imagen character varying(500),
    estado smallint DEFAULT 1 NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now() NOT NULL,
    comentario character varying(500),
    id_usr integer
);


--
-- Name: pais_id_pais_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pais_id_pais_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pais_id_pais_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pais_id_pais_seq OWNED BY public.pais.id_pais;


--
-- Name: perfil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.perfil (
    id_perfil integer NOT NULL,
    nombre character varying(50) NOT NULL
);


--
-- Name: perfil_id_perfil_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.perfil_id_perfil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: perfil_id_perfil_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.perfil_id_perfil_seq OWNED BY public.perfil.id_perfil;


--
-- Name: receta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receta (
    id_receta integer NOT NULL,
    nombre character varying(200) NOT NULL,
    url_imagen character varying(300) NOT NULL,
    ingrediente text DEFAULT ''::text,
    preparacion text NOT NULL,
    estado smallint DEFAULT 1 NOT NULL,
    id_cat integer NOT NULL,
    id_pais integer NOT NULL,
    fecha_creacion date DEFAULT now() NOT NULL,
    id_usr integer NOT NULL,
    visitas integer DEFAULT 0 NOT NULL
);


--
-- Name: receta_del_dia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receta_del_dia (
    fecha date NOT NULL,
    id_receta integer NOT NULL
);


--
-- Name: receta_id_receta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receta_id_receta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receta_id_receta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receta_id_receta_seq OWNED BY public.receta.id_receta;


--
-- Name: sesion_pago; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sesion_pago (
    id_sesion integer NOT NULL,
    session_id text NOT NULL,
    provider text DEFAULT 'unknown'::character varying NOT NULL,
    status text DEFAULT 'PENDING'::character varying NOT NULL,
    id_donacion integer,
    metadata jsonb,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    fecha_actualizacion timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sesion_pago_id_sesion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sesion_pago_id_sesion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sesion_pago_id_sesion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sesion_pago_id_sesion_seq OWNED BY public.sesion_pago.id_sesion;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id_usr integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    estado smallint DEFAULT 1 NOT NULL,
    fecha_creacion timestamp(6) without time zone DEFAULT now(),
    comentario character varying(255),
    id_perfil integer NOT NULL
);


--
-- Name: usuario_id_usr_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_id_usr_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario_id_usr_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuario_id_usr_seq OWNED BY public.usuario.id_usr;


--
-- Name: categoria id_cat; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id_cat SET DEFAULT nextval('public.categoria_id_cat_seq'::regclass);


--
-- Name: donacion id_donacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion ALTER COLUMN id_donacion SET DEFAULT nextval('public.donacion_id_donacion_seq'::regclass);


--
-- Name: estrella id_estrella; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estrella ALTER COLUMN id_estrella SET DEFAULT nextval('public.estrella_id_estrella_seq'::regclass);


--
-- Name: favorito id_fav; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorito ALTER COLUMN id_fav SET DEFAULT nextval('public.favorito_id_fav_seq'::regclass);


--
-- Name: ingrediente id_ingrediente; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingrediente ALTER COLUMN id_ingrediente SET DEFAULT nextval('public.ingrediente_new_id_ingrediente_seq'::regclass);


--
-- Name: me_gusta id_megusta; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.me_gusta ALTER COLUMN id_megusta SET DEFAULT nextval('public.me_gusta_id_megusta_seq'::regclass);


--
-- Name: pais id_pais; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pais ALTER COLUMN id_pais SET DEFAULT nextval('public.pais_id_pais_seq'::regclass);


--
-- Name: perfil id_perfil; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perfil ALTER COLUMN id_perfil SET DEFAULT nextval('public.perfil_id_perfil_seq'::regclass);


--
-- Name: receta id_receta; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta ALTER COLUMN id_receta SET DEFAULT nextval('public.receta_id_receta_seq'::regclass);


--
-- Name: sesion_pago id_sesion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sesion_pago ALTER COLUMN id_sesion SET DEFAULT nextval('public.sesion_pago_id_sesion_seq'::regclass);


--
-- Name: usuario id_usr; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usr SET DEFAULT nextval('public.usuario_id_usr_seq'::regclass);


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categoria (id_cat, nombre, url_imagen, estado, fecha_creacion, comentario, id_usr) FROM stdin;
19	Desayuno	https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcQ8n5bxzJh1iU5oECdzL6GYrRFGr_wRXXAWxKmmb01zMyClpmakwc9KzSG9DghIbd3CNI3gxKeBgY24b3lKK_m-cD8bBqLZPPMpSS28huHdLZ1TsIE	1	2023-06-27 11:19:33	\N	2
20	Vacuno	https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSxnHB9EC9gM34d7riLzUtok1ybFtIBvUQvK6KviPJcK7PmaaCoMI_PuAxd8BD0	1	2023-06-27 11:20:20	\N	2
21	Pollo	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyt2bNhPv4BuesF75CjDINvXhUktsKg8dgLh1WEyQ7CNWznZCL97Ro7NtHVR4Z	1	2023-06-27 11:20:29	\N	2
22	Postre	https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRuLl2x45bEiqADcQkcm8nDEsBdZOQFMvs0SsaU1UEjjssvkLkGMDUl5AnfGQw4	1	2023-06-27 11:20:44	\N	2
23	Cabrito	https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQzGJFzf15arOu0xT1y_l7ctYfoGjAM824dYSRHqpcuyEwQd2TFxqmevo3Q7kRq	1	2023-06-27 11:21:03	\N	2
24	Cordero	https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSlFHNtVRgs1TS5IZxGTysDVahTdjQfRkLMkFxnrtRIY1jOsak8E8ya3Ef3osuw	1	2023-06-27 11:21:15	\N	2
25	Varios	https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcS9oL4ZVJlvXljE5dxE_ViPiFbj8E7seEhatStw7kVk149PIpctkM_Rpbptff0U	1	2023-06-27 11:21:24	\N	2
26	Pasta	https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQvCQyQA_BVHk1rURehN9xZ62ah3i2en2jzafekEXjOg5Q-hHZMuEfEMdwLs_Gi	1	2023-06-27 11:21:37	\N	2
27	Cerdo	https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSWzY1BD8vpeLMduroA3uyY2BaWP-2454t6LuHLGpbeu8uBMzPzS5WE2oq0c4rR	1	2023-06-27 11:21:52	\N	2
28	Mariscos	https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRzP4mM7nKue5Q-mL2GdkB6j2ZNasRAibXWcNJgIifafb-toiMB3NTdT-LHFBg4	1	2023-06-27 11:22:05	\N	2
29	Acompa├▒amiento	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST8g6ipCC437gi4Mk-tppWofcx5VLAT7HgmVA45DlZ1R7nxO2OdOs7nu9pIPdL	1	2023-06-27 11:22:15	\N	2
30	Entrada	https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTutGyFTaGbUo4VM90u67PbXbJpZf0Qk9prBsfbPE2jyLNbM9-yyVZwtvYXwn7e	1	2023-06-27 11:40:32	\N	2
31	Vegano	https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSlmX6KvR3REikLwp4segzREuuT5UCkFhcgKS-i0_Wz-UWgrZDszSlGCO0h4d9U	1	2023-06-27 11:40:43	\N	2
32	Vegetariano	https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQwLWDbuFf4QSLIBzdXq4UIgEoL56LUIUfnU94Bxz2t7NzlAvhiw07NUIn72_Ng	1	2023-06-27 11:40:50	\N	2
\.


--
-- Data for Name: comentario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.comentario (id_comentario, fecha_creacion, id_receta, texto, id_usr) FROM stdin;
1480	2025-11-02 14:04:41.646716	8	Comentario final de prueba	68
1481	2025-11-02 14:52:11.273404	8	Comentario habilitado exitosamente	68
1484	2025-11-03 23:44:48.480696	8	Comentario de prueba 20:44:48	1
1485	2025-11-04 02:09:31.283405	8	test desde powershell	1
1486	2025-11-04 02:09:31.425657	8	test desde proxy	1
1487	2025-11-04 02:12:32.195821	8	test con usuario 3	1
1488	2025-11-04 02:15:22.937585	8	test sin id_usr	1
1489	2025-11-04 04:02:22.908744	12	perrororororororororo	3
1490	2025-11-04 20:37:39.68209	9	buena la receta, que tal la preparacion	3
1491	2025-11-04 20:44:58.302915	10	prueba de comentario 1	3
1492	2025-11-04 20:45:05.002878	10	prueba de comentario 2	3
1493	2025-11-04 21:01:42.995418	10	otro comentario ver como se ve	3
1494	2025-11-04 21:03:14.478006	10	otro mas comentario	3
1495	2025-11-04 21:12:01.329721	10	prueba de comentario 5	3
1496	2025-11-04 21:14:05.102733	10	prueba de comentario 6	3
\.


--
-- Data for Name: donacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donacion (id_donacion, amount, currency, fecha_actualizacion, fecha_creacion, id_receta, id_usr, status, stripe_payment_intent, stripe_session_id) FROM stdin;
\.


--
-- Data for Name: estrella; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estrella (id_estrella, fecha_creacion, valor, id_receta, id_usr) FROM stdin;
1	2025-11-02 03:10:19.49803	4	12	55
2	2025-11-02 10:56:33.946176	4	12	67
7	2025-11-02 13:42:36.891516	3	8	68
13	2025-11-04 03:53:33.881084	5	12	3
14	2025-11-04 20:37:45.71205	3	9	3
15	2025-11-04 20:44:08.494475	5	10	3
\.


--
-- Data for Name: favorito; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favorito (id_fav, fecha_creacion, id_receta, id_usr) FROM stdin;
1	2025-11-02 02:58:17.025785	12	55
14	2025-11-03 00:28:14.089603	8	78
18	2025-11-03 23:44:48.338187	8	1
23	2025-11-04 00:09:30.222345	8	3
24	2025-11-04 21:00:55.543619	10	3
\.


--
-- Data for Name: ingrediente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ingrediente (id_ingrediente, nombre, id_receta) FROM stdin;
17	2 pl├ítanos bien maduros (mientras m├ís manchas negras, m├ís dulces).\n\nHarina: 1 ┬¢ tazas de harina sin polvos de hornear (harina com├║n).\n\nPolvos de hornear: 1 ┬¢ cucharaditas.\n\nHuevo: 1 huevo grande.\n\nLeche: 1 taza (puede ser leche de vaca o vegetal).\n\nMantequilla: 2 cucharadas de mantequilla derretida (o aceite vegetal).\n\nAz├║car (Opcional): 1 a 2 cucharadas (los pl├ítanos maduros ya aportan dulzor).\n\nExtracto de vainilla: 1 cucharadita.\n\nSal: ┬╝ cucharadita.\n\nOpcional: ┬¢ cucharadita de canela en polvo.\n\nPara cocinar: Mantequilla o aceite para el sart├®n.	3
18	(Para 2 tazas)\nLeche entera: 2 tazas (480 ml).\n\nChocolate semiamargo: 100 g (aprox. 3.5 onzas), de buena calidad, troceado fino.\n\nCacao en polvo: 2 cucharadas, sin az├║car.\n\nAz├║car: 2 a 3 cucharadas (ajusta a tu gusto).\n\nMaicena (F├®cula de ma├¡z): 1 ┬¢ cucharadita (este es el secreto para la textura "fudge").\n\nExtracto de vainilla: ┬¢ cucharadita.\n\nSal: Una pizca peque├▒a.	4
19	Para la Carne:\n\nTapapecho (Brisket): 1 pieza de 1.5 a 2 kg. (P├¡delo con su capa de grasa, ya que esta da mucho sabor).\n\nHarina: 2 cucharadas (para enharinar la carne).\n\nSal y Pimienta negra: Abundante, por todos lados.\n\nAceite vegetal o manteca: 2-3 cucharadas.\n\nPara el Braseado (El l├¡quido y los vegetales):\n\nCebolla: 2 grandes, cortadas en pluma o cubos grandes.\n\nZanahorias: 3-4, peladas y cortadas en trozos r├║sticos (grandes).\n\nApio: 2-3 varas, cortadas en trozos grandes.\n\nAjo: 4 a 5 dientes, machacados o picados finos.\n\nVino Tinto: 1 taza (idealmente un Cabernet Sauvignon o Merlot).\n\nCaldo de Vacuno: 2 a 3 tazas (suficiente para cubrir la mitad de la carne).\n\nPasta de tomate (concentrado): 2 cucharadas.\n\nHierbas: 2 hojas de laurel, 2-3 ramitas de tomillo fresco (o 1 cucharadita de tomillo seco).\n\nPapas (Opcional, pero recomendado): 4-5 papas medianas, peladas y cortadas en cuartos (se agregan hacia el final).\n\nPara la Salsa (Gravy):\n\nMaicena (F├®cula de ma├¡z): 1 cucharada (disuelta en 2 cucharadas de agua fr├¡a), o mantequilla y harina (roux).	5
20	Para el Pollo y la Marinada:\n\nPollo: 1 pollo entero, cortado en 8 piezas (presas) con hueso y piel (muslos, trutros, pechugas, alas).\n\nButtermilk (Suero de leche): 2 tazas.\n\nSi no encuentras buttermilk: Mezcla 2 tazas de leche entera con 2 cucharadas de jugo de lim├│n o vinagre blanco. Deja reposar 10 minutos y tendr├ís un sustituto perfecto.\n\nHuevo: 1, batido.\n\nSalsa picante (opcional): 1 cucharada (tipo Tabasco o similar, para dar un toque).\n\nPara la Costra (Las "11 Hierbas y Especias"):\n\nHarina: 2 tazas de harina com├║n sin polvos.\n\nMaicena (F├®cula de ma├¡z): ┬¢ taza (esto a├▒ade crocancia extra).\n\nPiment├│n Dulce (Paprika): 2 cucharadas.\n\nPimienta Blanca: 1 cucharada (┬íEste es el sabor "secreto" de KFC!).\n\nPimienta Negra: 1 cucharada.\n\nSal: 2 cucharadas (parece mucho, pero sazona la harina y el pollo).\n\nAjo en polvo: 1 cucharada.\n\nCebolla en polvo: 1 cucharadita.\n\nTomillo seco: 1 cucharadita.\n\nOr├®gano seco: 1 cucharadita.\n\nJengibre en polvo: 1 cucharadita.\n\nMostaza en polvo: 1 cucharadita.\n\nSal de Apio: 1 cucharadita.\n\n(Opcional, el verdadero secreto): 1 cucharadita de Glutamato Monos├│dico (MSG o Ajinomoto). Esto es lo que le da el sabor "umami" adictivo de la comida r├ípida.\n\nPara Fre├¡r:\n\nAceite vegetal: Suficiente para fre├¡r (como maravilla, canola o man├¡). Aprox. 1.5 a 2 litros.	6
21	Para la Base:\n\nCarne Molida de Cerdo (Chancho): 500 g (1 libra).\n\nCebolla: 1 grande, picada en cubos finos (brunoise).\n\nAjo: 2 dientes, picados finos.\n\nPiment├│n Verde: ┬¢ (opcional, pero le da el toque cl├ísico de Sloppy Joe).\n\nAceite: 1 cucharada.\n\nPara la Salsa BBQ Casera:\n\nKetchup (K├®tchup): 1 taza.\n\nAz├║car Rubia (o Morena): ┬╝ taza (puedes ajustar la dulzura).\n\nVinagre de Manzana: 2 cucharadas (le da el toque ├ícido).\n\nSalsa Inglesa (Worcestershire): 1 cucharada.\n\nMostaza: 1 cucharada (tipo Dijon o la que tengas).\n\nPiment├│n Ahumado (o Paprika Ahumada): 1 cucharadita (clave para el sabor BBQ).\n\nComino en polvo: ┬¢ cucharadita.\n\nSal y Pimienta: A gusto.\n\nL├¡quido (Caldo o Agua): ┬¢ taza, para soltar la salsa.\n\nPara Servir:\n\nPan de Hamburguesa: 4 a 6 panes (el pan frica o marraqueta tambi├®n sirven).\n\nMantequilla: Para tostar los panes.\n\nOpcional (Recomendado): Ensalada Coleslaw, pepinillos dill, queso cheddar.	7
22	1. Ingredientes para la "Salsa Especial" (El Secreto)\nMayonesa: ┬¢ taza (la base de todo).\n\nPepinillos Dill (Encurtidos): 2 cucharadas, picados muy finos. (Si tienes "Sweet Relish" americano, es a├║n mejor, pero los pepinillos dill picados funcionan perfecto).\n\nMostaza Amarilla: 1 cucharada.\n\nCebolla en polvo: 1 cucharadita.\n\nAjo en polvo: ┬¢ cucharadita.\n\nPiment├│n dulce (Paprika): ┬¢ cucharadita (le da el color).\n\nVinagre blanco: 1 cucharadita.\n\nAz├║car: 1 cucharadita (solo si usas pepinillos dill, para balancear la acidez).\n\n2. Ingredientes para la Hamburguesa (por cada Big Mac)\nCarne molida de vacuno (80/20 ideal): 150 g, divididos en 2 hamburguesas muy delgadas.\n\nPan de hamburguesa: ┬íEl truco! Necesitas 1 pan con s├®samo completo y la base de un segundo pan. (Total: 3 piezas de pan).\n\nQueso Americano: 1 l├ímina de queso cheddar tipo "Kraft".\n\nLechuga Iceberg: Picada muy fina (chiffonade).\n\nCebolla blanca: 1 cucharada, picada en cubos diminutos.\n\nPepinillos Dill: 2 a 3 rodajas.\n\nSal y Pimienta.	8
23	1. Para las Berenjenas Asadas:\n\nBerenjenas: 2 grandes (tipo berenjena globo).\n\nAceite de Oliva: 3-4 cucharadas.\n\nSal y Pimienta: A gusto.\n\nOpcional (para sabor ahumado): 1 cucharadita de piment├│n ahumado (paprika ahumada).\n\n2. Para las Lentejas Sazonadas:\n\nLentejas: 1 taza (idealmente lentejas pardas, verdes o tipo "Puy", que mantienen su forma).\n\nAgua o Caldo de Verduras: 2-3 tazas.\n\nHoja de Laurel: 1 (opcional).\n\nJugo de Lim├│n: 1 cucharada.\n\nPerejil fresco: 2 cucharadas, picado fino.\n\nAceite de Oliva: 1 cucharada.\n\nSal y Pimienta: A gusto.\n\n3. Para la Salsa de Tahini:\n\nTahini (Pasta de s├®samo): ┬¢ taza.\n\nJugo de Lim├│n: 1 lim├│n (aprox. 3-4 cucharadas).\n\nAjo: 1 diente, picado muy fino o machacado.\n\nAgua Fr├¡a: ┬╝ a ┬¢ taza (para ajustar la consistencia).\n\nSal: ┬¢ cucharadita.\n\n4. Para el Montaje (Toppings):\n\nPi├▒ones (Pine Nuts): ┬╝ taza.\n\nSemillas de Granada: ┬╝ taza (┬ímuy recomendado! Aporta acidez y color).\n\nHojas de Menta o Perejil: Un pu├▒ado, para decorar.\n\nAceite de Oliva: Un chorrito extra virgen para finalizar.	9
32	Para la Masa:\n\nMasa para Pie (Doble Corteza): 2 discos (puedes usar masa pre-hecha refrigerada, tipo shortcrust pastry, o hacerla casera).\n\nHuevo: 1, batido con 1 cucharada de leche (para barnizar).\n\nPara el Relleno:\n\nCerdo Molido (Carne molida de cerdo): 1 libra (450 g).\n\nVacuno Molido (Carne molida de res): ┬¢ libra (225 g) (Opcional, pero recomendado. Tambi├®n se puede usar ternera).\n\nCebolla: 1 grande, picada muy fina (brunoise).\n\nAjo: 2 dientes, picados finos.\n\nPapa (Patata): 1 mediana, pelada y rallada fina (o ┬¢ taza de pur├® de papas).\n\nCaldo de Vacuno (o Pollo): 1 taza.\n\nMantequilla: 1 cucharada.\n\nSal y Pimienta: 1 cucharadita de sal, ┬¢ cucharadita de pimienta negra.\n\nLas Especias (┬íEl Secreto!):\n\nCanela en polvo: ┬¢ cucharadita.\n\nNuez Moscada: ┬╝ cucharadita.\n\nClavo de Olor molido: Ôàø de cucharadita (┬íEs muy fuerte, usa poco!).\n\nTomillo seco: ┬¢ cucharadita.\n\nSalvia seca (Sage): ┬¢ cucharadita (Opcional, pero muy tradicional).	18
24	Paso 1: Preparar y Pre-hornear la Masa\n\nHacer la Masa (si es casera): En un bol, mezcla la harina, az├║car flor y sal. Agrega la mantequilla fr├¡a y usa las yemas de tus dedos (o un procesador de alimentos) para "frotar" la mantequilla hasta que parezca arena gruesa.\n\nAgrega la yema de huevo y 1 cucharada de agua helada. Mezcla justo hasta que la masa se una. No la amases.\n\nEnvuelve la masa en pl├ístico y refrig├®rala por al menos 30 minutos.\n\nPre-hornear (Blind Bake): Precalienta el horno a 180┬░C (350┬░F).\n\nEstira la masa fr├¡a sobre una superficie enharinada y forra un molde de tarta (idealmente de 23 cm / 9 pulgadas con fondo removible). Pincha el fondo con un tenedor.\n\nCubre la masa con papel de hornear (mantequilla) y ll├®nalo con "pesos para hornear" (garbanzos o porotos secos funcionan perfecto).\n\nHornea por 15 minutos. Retira el papel y los pesos, y hornea por 5-10 minutos m├ís, hasta que la base est├® seca y ligeramente dorada. Reserva.\n\nPaso 2: Hacer el Frangipane\n\nMientras la masa se enfr├¡a, prepara el relleno.\n\nEn un bol, bate la mantequilla blanda y el az├║car granulada con una batidora el├®ctrica hasta que est├® p├ílida y esponjosa (cremada).\n\nA├▒ade el huevo y los extractos (vainilla y almendra). Bate bien.\n\nAgrega la harina de almendras, las 2 cucharadas de harina com├║n y la sal. Mezcla con una esp├ítula (no batas en exceso) hasta que est├® todo combinado. Tendr├ís una pasta espesa.\n\nPaso 3: Preparar las Manzanas\n\nCorta las manzanas en l├íminas finas (gajos).\n\nPonlas en un bol y roc├¡alas con el jugo de lim├│n para evitar que se pongan marrones.\n\nPaso 4: Armado y Horneado Final\n\nBaja la temperatura del horno a 175┬░C (350┬░F).\n\nToma tu base de tarta pre-horneada. Extiende el relleno de frangipane en una capa uniforme sobre el fondo.\n\nArreglar las Manzanas: Coloca las l├íminas de manzana sobre el frangipane. El dise├▒o cl├ísico es en c├¡rculos conc├®ntricos, superponiendo las l├íminas, comenzando desde el borde exterior hacia el centro (como una rosa).\n\nHornear: Hornea la tarta durante 40 a 50 minutos.\n\nEstar├í lista cuando el frangipane est├® inflado, dorado oscuro y firme al tacto (un palillo insertado en el centro debe salir limpio), y los bordes de las manzanas comiencen a caramelizarse.\n\nPaso 5: El Glaseado Brillante (El Toque Profesional)\n\nSaca la tarta del horno y d├®jala enfriar un poco.\n\nEn un taz├│n peque├▒o, calienta la mermelada de damasco en el microondas (o en una olla peque├▒a) con 1 cucharadita de agua hasta que est├® l├¡quida.\n\nCon una brocha de cocina, pinta suavemente la parte superior de las manzanas y la tarta con la mermelada caliente. Esto le da un brillo de pasteler├¡a profesional y un toque extra de sabor.\n\nD├®jala enfriar antes de desmoldar y servir. Es deliciosa tibia o a temperatura ambiente, acompa├▒ada de helado de vainilla.	10
25	Filete de Vacuno: 1 pieza central de 800g a 1kg (un corte cil├¡ndrico y parejo).\n\nMostaza Dijon: 2 cucharadas.\n\nAceite de Oliva: 2 cucharadas.\n\nSal y Pimienta Negra: Abundante.\n\nPara el Duxelles (Pasta de Champi├▒ones):\n\nChampi├▒ones: 400g (Par├¡s o Cremini).\n\nChalotas (o ┬¢ cebolla morada): 2 peque├▒as, picadas finas.\n\nAjo: 1 diente.\n\nTomillo fresco: 1 cucharada de hojas (o 1 cdta. de tomillo seco).\n\nMantequilla: 1 cucharada.\n\nPara el Armado:\n\nProsciutto (Jam├│n Serrano): 10 a 12 l├íminas.\n\nMasa de Hojaldre: 1 l├ímina grande (aprox. 30x40 cm), de buena calidad (que sea de pura mantequilla si es posible).\n\nHuevo: 1, batido (para el glaseado o egg wash).\n\nSal Gruesa: Para espolvorear.	11
26	1. Ingredientes para el Pur├® (El Topping)\nPapas: 1 kg (idealmente papas para pur├®, tipo Russet o Desir├®e).\n\nMantequilla: 3 cucharadas (aprox. 45g).\n\nLeche o Crema: ┬╝ taza, tibia.\n\nSal y Pimienta Blanca: A gusto.\n\nQueso Parmesano o Cheddar: ┬¢ taza (opcional, para gratinar).\n\n2. Ingredientes para el Relleno Cremoso\nLeche Entera: 2 ┬¢ tazas (aprox. 600 ml).\n\nHoja de Laurel: 1.\n\nGranos de Pimienta Entera: 5-6.\n\nPescado (El Mix Cl├ísico):\n\nPescado Blanco Firme: 300g (Reineta, Merluza, Bacalao fresco).\n\nPescado Ahumado: 200g (Salm├│n ahumado, o idealmente smoked haddock).\n\nCamarones: 150g, crudos y pelados.\n\nMantequilla: 3 cucharadas.\n\nHarina: 3 cucharadas (para el roux).\n\nPuerro (Leek): 1 grande, solo la parte blanca y verde claro, bien lavado y en rodajas finas (o 1 cebolla picada fina).\n\nArvejas (Guisantes): ┬¢ taza, congeladas.\n\nPerejil fresco: ┬╝ taza, picado fino.\n\nHuevos Duros (Opcional, pero muy tradicional): 2, cocidos y cortados en cuartos.\n\nNuez Moscada: Una pizca (esencial para la salsa blanca).\n\nSal: A gusto.	12
27	Tomates: 1 lata grande (800g / 28 oz) de tomates enteros pelados.\n\nMantequilla: 2 cucharadas.\n\nAceite de Oliva: 1 cucharada.\n\nCebolla: 1 grande, picada en cubos.\n\nAjo: 3-4 dientes, picados finos.\n\nZanahoria: 1 mediana, picada (opcional, pero a├▒ade dulzura natural).\n\nCaldo de Verduras (o Pollo): 2 tazas (aprox. 500 ml).\n\nCrema de Leche (Nata l├¡quida): ┬¢ a ┬¥ taza (aprox. 120-180 ml).\n\nAz├║car: 1 cucharadita (clave para balancear la acidez del tomate).\n\nHierbas: 1 cucharadita de or├®gano seco, o un manojo de albahaca fresca.\n\nSal y Pimienta Negra: A gusto.\n\nPara Servir (Opcional):\n\nCrutones (Croutons).\n\nUn chorrito de crema o aceite de oliva.\n\nHojas de albahaca fresca.	13
28	Para el Pastel de Pavo:\n\nPavo Molido (Carne molida de pavo): 1 kg (2 libras).\n\nCebolla: 1 grande, picada fina (brunoise).\n\nApio: 2 varas, picadas finas.\n\nZanahoria: 1 grande, rallada fina.\n\nAjo: 2 dientes, picados finos.\n\nAceite de Oliva: 1 cucharada.\n\nHuevos: 2, ligeramente batidos.\n\nPan Rallado (Panko o tradicional): ┬¥ taza.\n\nLeche Entera: ┬¢ taza.\n\nSalsa Inglesa (Worcestershire): 2 cucharadas (clave para el sabor umami).\n\nKetchup (K├®tchup): 2 cucharadas (para el interior).\n\nPerejil fresco: ┬╝ taza, picado fino.\n\nSal: 1 ┬¢ cucharaditas.\n\nPimienta Negra: 1 cucharadita.\n\nOpcional (Sabor): 1 cucharadita de tomillo seco o salvia seca.\n\nPara el Glaseado (La Cubierta):\n\nKetchup (K├®tchup): ┬¢ taza.\n\nAz├║car Rubia (o Morena): ┬╝ taza.\n\nVinagre de Manzana (o blanco): 1 cucharada.\n\nSalsa Inglesa (Worcestershire): 1 cucharada.	14
29	Para la Base:\n\nArroz: 1 taza de arroz crudo (coc├¡nalo seg├║n las instrucciones, resultar├í en unas 3 tazas de arroz cocido).\n\nBr├│coli: 1 cabeza grande, cortada en floretes peque├▒os.\n\nCebolla: 1 grande, picada fina.\n\nZanahoria: 1 grande, rallada fina (opcional, pero a├▒ade dulzor).\n\nAceite de Oliva: 1 cucharada.\n\nPara la Salsa de Queso (Bechamel):\n\nMantequilla: 3 cucharadas.\n\nHarina: 3 cucharadas.\n\nLeche Entera: 2 ┬¢ tazas.\n\nQueso Cheddar: 2 tazas, rallado (o 1 taza de cheddar y 1 de gruy├¿re).\n\nMostaza Dijon: 1 cucharadita (el secreto para potenciar el queso).\n\nNuez Moscada: ┬╝ cucharadita.\n\nSal y Pimienta: A gusto.\n\nPara la Cubierta Crujiente (Topping):\n\nPan Rallado (Panko es ideal): ┬¢ taza.\n\nMantequilla: 1 cucharada, derretida.\n\nQueso Parmesano (Opcional): ┬╝ taza, rallado.	15
30	Para la Masa:\n\nMasa para Pie (Doble Corteza): 2 discos (puedes usar masa pre-hecha refrigerada, tipo shortcrust pastry, o hacerla casera).\n\nHuevo: 1, batido con 1 cucharada de leche (para barnizar).\n\nAz├║car Gruesa: 1 cucharada (para espolvorear por encima).\n\nPara el Relleno (┬íEl Secreto!):\n\nFrutillas (Fresas): 2 ┬¢ tazas, lavadas, sin tallo y cortadas en cuartos.\n\nRuibarbo (Rhubarb): 2 ┬¢ tazas, cortado en trozos de 1 cm (aprox. 3-4 tallos).\n\nAz├║car Granulada: 1 taza (puedes ajustar a 1 ┬╝ tazas si te gusta m├ís dulce).\n\nMaicena (F├®cula de ma├¡z): Ôàô taza (Este es el espesante clave, ┬íno lo reduzcas!).\n\nJugo de Lim├│n: 1 cucharada.\n\nExtracto de Vainilla: 1 cucharadita.\n\nSal: ┬╝ cucharadita.\n\nMantequilla: 2 cucharadas, cortada en cubitos (para poner sobre el relleno).	16
31	Para el Sabor (La Base Ahumada):\n\nCodillo de Cerdo Ahumado (Ham Hock): 1 grande (o 2 peque├▒os).\n\nAlternativa f├ícil: 150g (5 oz) de tocino ahumado (bacon) o panceta, picado en cubos.\n\nArvejas Partidas Verdes (Split Peas): 1 libra (aprox. 500g), enjuagadas.\n\nCaldo de Pollo (o Verduras): 8 tazas (aprox. 2 litros).\n\nAceite de Oliva: 1 cucharada (om├¡telo si usas tocino).\n\nLos Arom├íticos (El "Mirepoix"):\n\nCebolla: 1 grande, picada en cubos.\n\nZanahorias: 2 medianas, picadas en cubos.\n\nApio: 2 varas, picadas en cubos.\n\nAjo: 3-4 dientes, picados finos.\n\nHierbas y Sazonadores:\n\nHojas de Laurel: 2.\n\nTomillo Seco: 1 cucharadita (o 3-4 ramitas de tomillo fresco).\n\nPimienta Negra Molida: Abundante, a gusto.\n\nSal: A gusto (┬íprobar al final!).\n\nPara Servir (Opcional):\n\nCrutones (Croutons).\n\nUn chorrito de aceite de oliva virgen extra.\n\nPerejil fresco picado.	17
33	Tapapecho Curado (Corned Beef Brisket): 1 pieza (aprox. 1.5 - 2 kg). Viene envasado al vac├¡o en salmuera.\n\nAgua: Suficiente para cubrir la carne.\n\nMostaza Amarilla: 2-3 cucharadas (solo como "pegamento" para el rub).\n\nPara el Rub (La Costra de Especias):\n\nPimienta Negra en Grano: ┬╝ taza.\n\nSemillas de Coriandro (Cilantro): ┬╝ taza.\n\nPiment├│n Dulce (Paprika): 1 cucharada.\n\nAjo en Polvo: 1 cucharada.\n\nCebolla en Polvo: 1 cucharada.\n\n(Opcional): 1 cucharadita de eneldo seco, 1 cucharadita de mostaza en polvo.\n\nEquipamiento Necesario\nUn ahumador (smoker), o un asador (parrilla) con tapa que puedas usar para ahumar indirectamente.\n\nAstillas o trozos de madera para ahumar (el roble o nogal americano van bien).\n\nUna bandeja de aluminio.\n\nTerm├│metro de carne.	19
36	Para la Masa (aprox. 30-40 Timbits):\n\nHarina: 2 ┬¢ tazas (aprox. 300 g).\n\nAz├║car Granulada: ┬¥ taza (150 g).\n\nPolvos de Hornear: 2 cucharaditas.\n\nNuez Moscada: ┬¢ cucharadita (┬íEste es el sabor secreto de las donas cl├ísicas!).\n\nSal: ┬¢ cucharadita.\n\nHuevos: 2 grandes.\n\nMantequilla: ┬╝ taza (55 g), derretida.\n\nButtermilk (Suero de Leche): ┬¥ taza (180 ml).\n\nSi no tienes Buttermilk: Mezcla ┬¥ taza de leche con 2 cucharaditas de jugo de lim├│n o vinagre blanco. Deja reposar 5 minutos.\n\nExtracto de Vainilla: 1 cucharadita.\n\nPara Fre├¡r:\n\nAceite Vegetal: Aprox. 1.5 litros (como aceite de canola, maravilla o man├¡).\n\nOpciones de Cobertura (┬íPrepara esto primero!)\nOpci├│n 1: Az├║car y Canela\n\n┬¢ taza de az├║car granulada.\n\n1 cucharadita de canela en polvo.\n\nM├®zclalos en un plato hondo.\n\nOpci├│n 2: Glaseado Cl├ísico\n\n1 ┬¢ tazas de az├║car flor (glass), cernida.\n\n3-4 cucharadas de leche o crema.\n\n┬¢ cucharadita de vainilla.\n\nB├ítelos en un bol hasta que quede suave.\n\nOpci├│n 3: Glaseado de Chocolate\n\nSigue la receta del "Glaseado Cl├ísico", pero a├▒ade 2 cucharadas de cacao en polvo (cernido).\n\nOpci├│n 4: "Birthday Cake" (Cumplea├▒os)\n\nA├▒ade 2-3 cucharadas de chispitas de colores (sprinkles) a la masa al final.\n\n├Üntalos con el "Glaseado Cl├ísico" y decora con m├ís chispitas por encima.	20
37	Para la Capa de Papas (Arriba):\n\nPapas: 1 kg (aprox. 4-5 papas grandes), peladas y en cubos.\n\nMantequilla: ┬╝ taza (55 g).\n\nLeche Entera: ┬¢ taza, tibia.\n\nSal y Pimienta: A gusto.\n\nPara la Capa de Carne (Abajo):\n\nCarne Molida de Vacuno: 1 libra (aprox. 500 g).\n\nCebolla: 1 grande, picada fina (brunoise).\n\nAceite o Mantequilla: 1 cucharada.\n\nSal y Pimienta: Al gusto (aprox. 1 cucharadita de sal).\n\nOpcional: 1 cucharada de ketchup o un chorrito de salsa inglesa.\n\nPara la Capa Central (┬íEl Secreto!):\n\nChoclo en Crema (Creamed Corn): 1 lata grande (aprox. 420 g / 15 oz).\n\nOpcional: 1 lata de choclo en grano (ma├¡z dulce), escurrido, si te gusta con m├ís textura.\n\nPara el Acabado:\n\nPiment├│n (Paprika): Para espolvorear por encima.\n\nMantequilla: 1 cucharada extra en cubitos (opcional).	21
38	Masa para Pie: 1 disco (para una base de 9 pulgadas / 23 cm). Puede ser masa quebrada casera o pre-hecha.\n\nAz├║car Rubia (Morena): 1 ┬¢ tazas, bien compactada.\n\nCrema de Leche (Nata l├¡quida): 1 taza (con alto contenido de grasa, 35% o m├ís).\n\nMantequilla sin sal: ┬╝ taza (55 g), derretida.\n\nHarina com├║n: 3 cucharadas.\n\nExtracto de Vainilla: 1 cucharadita.\n\nSal: ┬╝ cucharadita (esencial para balancear el dulzor).\n\nOpcional (El toque de Qu├®bec): ┬╝ taza de Sirope de Maple (Jarabe de Arce) puro. Si lo usas, reduce el az├║car rubia a 1 ┬╝ tazas.	22
39	Papas: 700g (aprox. 3-4 papas medianas). Idealmente papas de piel roja o Yukon Gold (papas "harinosas" como la Desir├®e en Chile funcionan bien).\n\nCebolla: 1 mediana, picada en cubos (brunoise).\n\nPiment├│n (Pimiento Morr├│n): 1 (rojo o verde), picado en cubos. (Opcional, pero muy cl├ísico).\n\nMantequilla: 2 cucharadas.\n\nAceite Vegetal (Maravilla, Canola): 2 cucharadas (la mezcla de aceite y mantequilla da sabor y evita que se queme).\n\nSal: 1 cucharadita.\n\nPimienta Negra: ┬¢ cucharadita.\n\nPiment├│n Dulce (Paprika): 1 cucharadita (clave para el color y sabor).\n\nAjo en Polvo (Opcional): ┬¢ cucharadita.\n\nPerejil fresco: Picado, para decorar.	23
40	Para el Caldo (La Base):\n\nCaldo de Pescado o Mariscos: 1.5 litros (6 tazas), de buena calidad.\n\nAzafr├ín (Saffron): Unas hebras generosas (esencial para el color y aroma).\n\nPara los Mariscos (El Mix):\n\nGambas o Langostinos: 8-10 grandes, con c├íscara.\n\nMejillones (Choritos): 1 taza, limpios.\n\nAlmejas: 1 taza, limpias.\n\nCalamar o Sepia: 1 grande, limpio y cortado en anillas o cubos.\n\n(Opcional): Trozos de pescado blanco firme (Rape/Monkfish es el cl├ísico).\n\nPara los Fideos y el Sofrito:\n\nFideos (tipo "Fideu├á" o "Cabello de ├üngel corto"): 300g (aprox. 10 oz). Si no encuentras fideos para fideu├á, puedes usar cabello de ├íngel y romperlo con las manos.\n\nTomates: 2 tomates maduros, rallados (o ┬¢ taza de tomate triturado).\n\nCebolla: 1, picada muy fina (brunoise).\n\nAjo: 3-4 dientes, picados finos.\n\nPiment├│n Dulce (Paprika dulce): 1 cucharadita (┬íEsencial! Idealmente piment├│n espa├▒ol).\n\nAceite de Oliva Virgen Extra: Abundante.\n\nVino Blanco (Opcional): Un chorrito para los mejillones.\n\nSal y Pimienta: A gusto.\n\nPara Servir (┬íObligatorio!):\n\nAllioli: (Mayonesa de ajo casera o comprada).\n\nLim├│n: Cortado en gajos.	24
41	Papas: 600-700g (aprox. 3-4 papas medianas).\n\nHuevos: 6 huevos grandes (la proporci├│n es clave para la jugosidad).\n\nCebolla: 1 grande (este es un debate nacional en Espa├▒a, pero la tortilla cl├ísica con cebolla es m├ís dulce y jugosa).\n\nAceite de Oliva Virgen Extra: Abundante para la cocci├│n (al menos 1 taza). No te preocupes, la mayor├¡a se escurre y se puede reutilizar.\n\nSal: A gusto.\n\nEquipamiento Esencial\nUn sart├®n antiadherente de buena calidad (de unos 22-24 cm).\n\nUn plato llano grande (m├ís ancho que el sart├®n) para "el volteo".	25
42	Para las Verduras Asadas:\n\nBerenjena: 1 grande, cortada en cubos de 2 cm.\n\nHinojo (Fennel): 1 bulbo grande, cortado en gajos finos.\n\nAceite de Oliva: 3-4 cucharadas.\n\nSal y Pimienta: A gusto.\n\nPara el Caldo (La Base):\n\nCaldo de Verduras: 1.2 litros (aprox. 5 tazas). Debe ser un caldo sabroso.\n\nAzafr├ín: Unas hebras generosas (esencial).\n\nPara el Sofrito y Arroz:\n\nArroz (Tipo Paella): 1 ┬¢ tazas (aprox. 300g). Idealmente Arroz Bomba o Calasparra.\n\nAceite de Oliva Virgen Extra: 4 cucharadas.\n\nCebolla: 1 grande, picada fina (brunoise).\n\nPiment├│n Rojo: 1, picado fino.\n\nAjo: 3-4 dientes, picados finos.\n\nTomate: 2 tomates maduros, rallados (sin piel) o 1 taza de tomate triturado.\n\nPiment├│n Ahumado (Piment├│n de la Vera): 1 cucharada rasa (┬íclave!).\n\nSal: A gusto.\n\nPara Servir:\n\nPerejil Fresco: Un manojo, picado.\n\nLim├│n: 1, cortado en gajos.	26
43	Para la Base:\n\nPollo Cocido: 3-4 tazas, deshebrado (un pollo asado/rostizado comprado es el atajo perfecto para esto).\n\nTortillas de Ma├¡z: 12 a 15 (┬íno de harina!).\n\nAceite Vegetal: ┬¢ taza (para fre├¡r las tortillas).\n\nPara la Salsa y el Relleno:\n\nSalsa de Enchilada Roja: 1 lata grande (800g / 28 oz) o 3-4 tazas de salsa casera.\n\nQueso para derretir: 4 tazas (aprox. 400g), rallado. (Idealmente una mezcla de Monterey Jack, Cheddar o queso Mexicano).\n\nFrijoles Negros (Porotos Negros): 1 lata (425g / 15 oz), enjuagados y escurridos.\n\nChoclo (Ma├¡z Dulce): 1 lata (425g / 15 oz), escurrido.\n\nQueso Crema (Philadelphia): 110g (4 oz), a temperatura ambiente (┬íEste es el secreto para un relleno cremoso!).\n\nCebolla: 1, picada fina (opcional).\n\nPara Servir (Opcional):\n\nCrema Agria (Sour Cream) o Crema espesa.\n\nPalta (Aguacate) en cubos.\n\nCilantro fresco picado.\n\nJalape├▒os en rodajas.	27
44	(Puedes comprar "Cajun Seasoning" hecho, pero hacerlo casero es mucho mejor. Mezcla esto en un bol peque├▒o):\n\nPiment├│n Dulce (Paprika): 2 cucharadas (idealmente ahumado, si tienes).\n\nAjo en Polvo: 1 cucharada.\n\nCebolla en Polvo: 1 cucharada.\n\nPimienta de Cayena (Aj├¡ en polvo): 1 cucharadita (┬íajusta esto a tu gusto de picante!).\n\nOr├®gano Seco: 1 cucharadita.\n\nTomillo Seco: 1 cucharadita.\n\nPimienta Negra Molida: 1 cucharadita.\n\nSal: 1 cucharadita.\n\n2. Ingredientes: Para el Pescado y los Tacos\nPescado Blanco Firme: 500g (Reineta, Merluza, Tilapia o Bacalao funcionan perfecto), cortado en trozos o tiras.\n\nAceite Vegetal: 2 cucharadas (para fre├¡r).\n\nTortillas de Ma├¡z: 8-10 peque├▒as.\n\nLimones Sutiles (Limas): Cortados en gajos, para servir.\n\n3. Ingredientes: Para la Salsa de Palta y Cilantro (La Crema)\nPalta (Aguacate): 1 grande.\n\nCilantro: ┬¢ manojo.\n\nYogur Griego Natural (o Crema Agria): ┬¢ taza.\n\nJugo de Lim├│n Sutil: 1 (entero).\n\nAjo: 1 diente peque├▒o (opcional).\n\nAgua: 2-3 cucharadas (para soltar la textura).\n\nSal: A gusto.\n\n4. Ingredientes: Para la Ensalada (Slaw) R├ípida\nRepollo (Col): 2 tazas, picado fino (morado o blanco).\n\nZanahoria: 1, rallada (opcional).\n\nCilantro: ┬╝ manojo, picado.\n\nJugo de Lim├│n Sutil: ┬¢.\n\nSal: Una pizca.	28
45	Para la Carne:\n\nCarne de Vacuno para estofar: 1.5 kg (idealmente lomo vetado, huachalomo, o tapapecho).\n\nHarina: ┬╝ taza (para enharinar).\n\nSal y Pimienta: A gusto.\n\nAceite Vegetal: 3-4 cucharadas.\n\nPara el Sofrito y Especias:\n\nCebollas: 2 grandes, picadas en cubos.\n\nPiment├│n Rojo: 1, picado en cubos.\n\nJalape├▒os: 1-2 (opcional, para el picor), picados finos (sin semillas para menos picor).\n\nAjo: 6-8 dientes, picados finos.\n\nPasta de Tomate (Concentrado): 2 cucharadas.\n\nAj├¡ en Polvo (Chili Powder): 3-4 cucharadas (┬íel coraz├│n del plato!).\n\nComino Molido: 1 cucharada.\n\nPiment├│n Ahumado (Smoked Paprika): 1 cucharada.\n\nOr├®gano Seco: 1 cucharada.\n\nPara el Braseado (El L├¡quido):\n\nCerveza Negra (tipo Stout o Bock): 1 lata o botella (aprox. 330 ml).\n\nCaldo de Vacuno: 3-4 tazas.\n\nTomates Triturados (o en Cubos): 1 lata grande (800g / 28 oz).\n\nHojas de Laurel: 2.\n\nIngrediente Secreto (Opcional): 2 cucharadas de cacao en polvo (sin az├║car) o 30g de chocolate amargo (sobre 70%).\n\nPara Terminar:\n\nPorotos Negros (Frijoles): 1 lata (425g), enjuagados y escurridos (Opcional, el chili estilo Texas no lleva, pero son un buen a├▒adido).\n\nMaicena (F├®cula de ma├¡z) o Masa Harina: 2 cucharadas (disueltas en 2 cucharadas de agua), para espesar.\n\nJugo de Lim├│n Sutil o Vinagre de Manzana: 1 chorrito (para "despertar" los sabores).\n\nAcompa├▒amientos Cl├ísicos (Toppings):\n\nCrema agria (Sour cream)\n\nQueso cheddar rallado\n\nPalta (aguacate) en cubos\n\nCilantro fresco\n\nCeboll├¡n picado	29
46	Esta receta tiene dos partes: preparar el pollo en la olla lenta (que puedes hacer con horas de anticipaci├│n) y luego el armado y horneado r├ípido.\n\n1. Ingredientes: Para el Pollo en Olla Lenta (Crock-Pot)\nPechugas de Pollo: 1 kg (aprox. 3-4 pechugas sin hueso y sin piel).\n\nSalsa (tipo mexicana, de frasco): 1 frasco de 450g (16 oz).\n\nSazonador de Tacos (Taco Seasoning): 1 sobre (o 3 cucharadas de sazonador casero).\n\nCaldo de Pollo (Opcional): ┬╝ taza, si la salsa es muy espesa.\n\n2. Ingredientes: Para el Armado y Horneado\nTaco Shells (Tacos r├¡gidos): 12 unidades (los que vienen con fondo plano, tipo "Stand N Stuff", son los m├ís f├íciles para esto).\n\nPorotos Refritos (Frijoles Refritos): 1 lata (opcional, pero muy recomendado).\n\nQueso Rallado (Mezcla Mexicana o Cheddar): 2 tazas.\n\n3. Ingredientes: Para los Acompa├▒amientos (Toppings)\nCrema agria (Sour cream)\n\nLechuga picada fina\n\nTomates en cubos\n\nPalta (aguacate) o Guacamole\n\nCilantro fresco	30
47	1. Ingredientes: Sazonador de Fajitas (El Sabor)\nMezcla esto primero en un bol peque├▒o. (O usa un sobre de saz├│n para fajitas comprado).\n\nAj├¡ en Polvo (Chili Powder): 2 cucharaditas.\n\nComino Molido: 1 ┬¢ cucharaditas.\n\nPiment├│n Ahumado (Smoked Paprika): 1 ┬¢ cucharaditas (┬íeste es el secreto!).\n\nAjo en Polvo: 1 cucharadita.\n\nCebolla en Polvo: 1 cucharadita.\n\nOr├®gano Seco: 1 cucharadita.\n\nPimienta de Cayena: ┬╝ cucharadita (o al gusto).\n\nSal: 1 cucharadita.\n\nPimienta Negra: ┬¢ cucharadita.\n\n2. Ingredientes: Para la Bandeja de Fajitas\nGarbanzos: 1 lata (425g / 15 oz), enjuagados y escurridos.\n\nPiment├│n (Pimiento Morr├│n): 2 grandes, de colores (rojo y amarillo), cortados en tiras.\n\nCebolla Morada: 1 grande, cortada en tiras gruesas (pluma).\n\nAceite de Oliva: 3 cucharadas.\n\nJugo de Lim├│n Sutil (Lima): 1 (entero).\n\n3. Ingredientes: Para Servir\nTortillas: 8-10 tortillas (de harina o ma├¡z).\n\nPalta (Aguacate): En rodajas o como guacamole.\n\nSalsa: Pico de Gallo o tu salsa roja favorita.\n\nCrema Agria (Sour Cream): O yogur griego natural.\n\nCilantro Fresco: Picado.	31
48	Para los Pimentones:\n\nPimentones (Bell Peppers): 4 grandes, de cualquier color (los rojos, amarillos o naranjas son m├ís dulces).\n\nAceite de Oliva: 1 cucharada.\n\nSal y Pimienta: A gusto.\n\nPara el Relleno:\n\nQuinoa: 1 taza, cruda.\n\nCaldo de Verduras (o Agua): 2 tazas.\n\nPorotos Negros (Frijoles Negros): 1 lata (425g), enjuagados y escurridos.\n\nChoclo (Ma├¡z Dulce): 1 lata (425g), escurrido.\n\nCebolla: 1 mediana, picada fina (brunoise).\n\nAjo: 3 dientes, picados finos.\n\nAceite de Oliva: 1 cucharada.\n\nSalsa de Tomate (Triturada): 1 taza.\n\nCilantro Fresco: ┬¢ manojo, picado.\n\nJugo de Lim├│n Sutil (Lima): 1 (entero).\n\nSazonador (La Clave del Sabor):\n\nComino Molido: 2 cucharaditas.\n\nPiment├│n Ahumado (Smoked Paprika): 1 cucharadita (┬íno lo omitas!).\n\nAj├¡ en Polvo (Chili Powder): 1 cucharadita (opcional, para un toque picante).\n\nSal: 1 cucharadita (o al gusto).\n\nPimienta Negra: ┬¢ cucharadita.\n\nPara el Acabado (Opcional):\n\nQueso Rallado: 1 taza (tipo Monterey Jack, Cheddar o Queso Mantecoso).\n\nAlternativa Vegana: Levadura nutricional o queso vegano.\n\nPara Servir:\n\nPalta (aguacate) en rodajas.\n\nCrema agria (o yogur griego).	32
\.


--
-- Data for Name: me_gusta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.me_gusta (id_megusta, fecha_creacion, id_receta, id_usr) FROM stdin;
2	2025-11-01 18:46:19.772205	8	1
1	2025-11-01 18:30:11.484725	8	2
3	2025-11-02 02:58:13.842658	12	55
9	2025-11-03 00:03:13.634768	8	72
10	2025-11-03 00:03:20.607135	8	73
11	2025-11-03 00:06:07.304679	8	74
19	2025-11-04 00:00:45.863062	8	3
21	2025-11-04 21:00:52.866597	10	3
\.


--
-- Data for Name: pais; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pais (id_pais, nombre, url_imagen, estado, fecha_creacion, comentario, id_usr) FROM stdin;
89	EEUU	https://www.themealdb.com/images/icons/flags/big/64/us.png	1	2023-06-26 23:58:57	\N	1
90	Inglaterra	https://www.themealdb.com/images/icons/flags/big/64/gb.png	1	2023-06-27 10:00:19	\N	1
91	Canada	https://www.themealdb.com/images/icons/flags/big/64/ca.png	1	2023-06-27 10:55:58	\N	1
92	Espa├▒a	https://www.themealdb.com/images/icons/flags/big/64/es.png	1	2023-06-27 10:57:06	\N	1
93	Mexico	https://www.themealdb.com/images/icons/flags/big/64/mx.png	1	2023-06-27 10:57:47	\N	1
94	Argentina	https://www.themealdb.com/images/icons/flags/big/64/ar.png	1	2023-06-27 10:59:34	\N	1
\.


--
-- Data for Name: perfil; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.perfil (id_perfil, nombre) FROM stdin;
3	ADMIN
2	LIDER
1	USER
\.


--
-- Data for Name: receta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.receta (id_receta, nombre, url_imagen, ingrediente, preparacion, estado, id_cat, id_pais, fecha_creacion, id_usr, visitas) FROM stdin;
8	Big Mac	https://www.themealdb.com/images/media/meals/urzj1d1587670726.jpg		Hacer la Salsa (Hacer primero): En un bol peque├▒o, mezcla TODOS los ingredientes de la "Salsa Especial". Bate bien, c├║brelo y refrigera por al menos 1 hora. Este reposo es fundamental.\n\nPreparar los Vegetales: Pica la lechuga iceberg muy fina. Pica la cebolla blanca lo m├ís fino que puedas (casi polvo).\n\nPro-Tip: Para imitar el sabor suave de la cebolla de McDonald's, remoja la cebolla picada en un bol con agua fr├¡a por 10 minutos y luego esc├║rrela bien.\n\nPreparar los Panes: Tuesta las 3 piezas de pan (la tapa con s├®samo, la base del medio y la base de abajo) en un sart├®n con un poco de mantequilla o en una plancha hasta que est├®n dorados.\n\nCocinar las Hamburguesas:\n\nForma 2 hamburguesas muy delgadas y planas, un poco m├ís anchas que el pan (se encoger├ín al cocinarlas).\n\nCalienta un sart├®n o plancha a fuego alto.\n\nCocina las hamburguesas 1-2 minutos por lado. No las sazones antes.\n\nAl voltearlas, saz├│nalas en el sart├®n con sal y pimienta.\n\nEn los ├║ltimos 30 segundos, pon la l├ímina de queso sobre una de las hamburguesas para que se derrita.\n\n5. El Montaje (El Ritual)\nAqu├¡ es donde se crea la magia, de abajo hacia arriba:\n\nPan de Abajo (Base):\n\nUna cucharada generosa de Salsa Especial.\n\nUna pizca de cebolla picada.\n\nUn pu├▒ado de lechuga picada.\n\nLa hamburguesa que tiene el queso derretido.\n\nPan del Medio:\n\nColoca la base del segundo pan encima de la primera hamburguesa.\n\nUna cucharada de Salsa Especial.\n\nUna pizca de cebolla picada.\n\nUn pu├▒ado de lechuga picada.\n\nLas rodajas de pepinillo.\n\nLa segunda hamburguesa (sin queso).\n\nTapa:\n\nColoca la tapa del pan (la que tiene s├®samo) encima de todo.	1	20	89	2023-06-27	1	0
5	Asado a la Olla de Tapapecho	https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRX5IlLANtrdF5CfGNbuKCzWh5_-bU2EN3pOEvL6pqt7ClITa9Pcfc5wzXxnIRv		Preparar la Carne (Crucial): Seca muy bien la pieza de carne con toalla de papel. Sazona generosamente por todos los lados con sal y pimienta. Pasa la carne ligeramente por harina (esto ayudar├í a dorar y a espesar la salsa despu├®s).\n\nSellar la Carne: Calienta el aceite o manteca en una olla grande y de fondo grueso (idealmente de hierro fundido) a fuego alto. Sella la carne por todos sus lados hasta que est├® muy dorada (marr├│n oscuro). No la muevas mientras se sella. Retira la carne de la olla y res├®rvala en un plato.\n\nEl Sofrito (Base del sabor): En la misma olla, baja el fuego a medio. Agrega la cebolla, las zanahorias y el apio. Sofr├¡e por 8-10 minutos, raspando el fondo de la olla con una cuchara de madera para soltar los trocitos dorados de la carne.\n\nA├▒adir Arom├íticos: Agrega el ajo y la pasta de tomate. Revuelve y cocina por 2 minutos m├ís, hasta que la pasta de tomate cambie a un color m├ís oscuro.\n\nDesglasar con Vino: Sube el fuego y vierte el vino tinto. Deja que hierva fuerte, raspando el fondo vigorosamente. Deja que el vino se reduzca a la mitad (unos 3-4 minutos).\n\nEl Braseado (Cocci├│n Lenta): Regresa la carne a la olla (con el lado de la grasa hacia arriba). Agrega el caldo de vacuno (debe llegar hasta la mitad de la carne, no cubrirla por completo), las hojas de laurel y el tomillo.\n\nCocinar: Lleva la olla a un hervor suave, luego baja el fuego al m├¡nimo posible, tapa la olla herm├®ticamente y deja cocinar.\n\nTiempo de cocci├│n: De 3 a 4 horas. La carne estar├í lista cuando puedas insertar un tenedor y sacarlo sin ninguna resistencia.\n\nAgregar las Papas (Opcional): Si vas a usar papas, agr├®galas a la olla durante los ├║ltimos 45-60 minutos de cocci├│n, para que se cocinen en el caldo pero no se desarmen.\n\nReposar la Carne (┬íImportante!): Con mucho cuidado, saca la carne de la olla y ponla en una tabla de cortar. C├║brela con papel aluminio y d├®jala reposar por 15 minutos. No te saltes este paso, es vital para que los jugos se redistribuyan y quede tierna.\n\nHacer la Salsa (Gravy): Cuela el l├¡quido que qued├│ en la olla (puedes dejar algunos vegetales si prefieres). Vuelve a poner el l├¡quido en la olla a fuego medio. Si la salsa est├í muy l├¡quida, espesa agregando la mezcla de maicena disuelta en agua fr├¡a y batiendo hasta que hierva y espese.\n\nServir: Corta la carne. Importante: El tapapecho tiene una veta (fibra) muy marcada; debes cortarlo siempre en contra de la veta para asegurar la m├íxima ternura. Sirve la carne ba├▒ada en su salsa (gravy) y acompa├▒ada de los vegetales.	1	20	89	2023-06-27	1	0
10	Tarta de Manzana y Frangipane	https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg		Paso 1: Preparar y Pre-hornear la Masa\n\nHacer la Masa (si es casera): En un bol, mezcla la harina, az├║car flor y sal. Agrega la mantequilla fr├¡a y usa las yemas de tus dedos (o un procesador de alimentos) para "frotar" la mantequilla hasta que parezca arena gruesa.\n\nAgrega la yema de huevo y 1 cucharada de agua helada. Mezcla justo hasta que la masa se una. No la amases.\n\nEnvuelve la masa en pl├ístico y refrig├®rala por al menos 30 minutos.\n\nPre-hornear (Blind Bake): Precalienta el horno a 180┬░C (350┬░F).\n\nEstira la masa fr├¡a sobre una superficie enharinada y forra un molde de tarta (idealmente de 23 cm / 9 pulgadas con fondo removible). Pincha el fondo con un tenedor.\n\nCubre la masa con papel de hornear (mantequilla) y ll├®nalo con "pesos para hornear" (garbanzos o porotos secos funcionan perfecto).\n\nHornea por 15 minutos. Retira el papel y los pesos, y hornea por 5-10 minutos m├ís, hasta que la base est├® seca y ligeramente dorada. Reserva.\n\nPaso 2: Hacer el Frangipane\n\nMientras la masa se enfr├¡a, prepara el relleno.\n\nEn un bol, bate la mantequilla blanda y el az├║car granulada con una batidora el├®ctrica hasta que est├® p├ílida y esponjosa (cremada).\n\nA├▒ade el huevo y los extractos (vainilla y almendra). Bate bien.\n\nAgrega la harina de almendras, las 2 cucharadas de harina com├║n y la sal. Mezcla con una esp├ítula (no batas en exceso) hasta que est├® todo combinado. Tendr├ís una pasta espesa.\n\nPaso 3: Preparar las Manzanas\n\nCorta las manzanas en l├íminas finas (gajos).\n\nPonlas en un bol y roc├¡alas con el jugo de lim├│n para evitar que se pongan marrones.\n\nPaso 4: Armado y Horneado Final\n\nBaja la temperatura del horno a 175┬░C (350┬░F).\n\nToma tu base de tarta pre-horneada. Extiende el relleno de frangipane en una capa uniforme sobre el fondo.\n\nArreglar las Manzanas: Coloca las l├íminas de manzana sobre el frangipane. El dise├▒o cl├ísico es en c├¡rculos conc├®ntricos, superponiendo las l├íminas, comenzando desde el borde exterior hacia el centro (como una rosa).\n\nHornear: Hornea la tarta durante 40 a 50 minutos.\n\nEstar├í lista cuando el frangipane est├® inflado, dorado oscuro y firme al tacto (un palillo insertado en el centro debe salir limpio), y los bordes de las manzanas comiencen a caramelizarse.\n\nPaso 5: El Glaseado Brillante (El Toque Profesional)\n\nSaca la tarta del horno y d├®jala enfriar un poco.\n\nEn un taz├│n peque├▒o, calienta la mermelada de damasco en el microondas (o en una olla peque├▒a) con 1 cucharadita de agua hasta que est├® l├¡quida.\n\nCon una brocha de cocina, pinta suavemente la parte superior de las manzanas y la tarta con la mermelada caliente. Esto le da un brillo de pasteler├¡a profesional y un toque extra de sabor.\n\nD├®jala enfriar antes de desmoldar y servir. Es deliciosa tibia o a temperatura ambiente, acompa├▒ada de helado de vainilla.	1	22	90	2023-06-27	1	0
11	Filete Wellington	https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg		Fase 1: El Filete (Hacer con anticipaci├│n)\nSazonar: Saca el filete del refrigerador 30 minutos antes de cocinar. S├®calo muy bien con toalla de papel y saz├│nalo generosamente por todos sus lados con sal y pimienta.\n\nSellar: Calienta un sart├®n muy grande a fuego alto con el aceite. Sella el filete por todos sus lados (incluyendo las puntas) muy r├ípidamente, solo 1-2 minutos por lado. Buscas un color dorado oscuro, no cocinarlo por dentro.\n\nLa Mostaza: Retira el filete del fuego e, inmediatamente mientras est├í caliente, p├¡ntalo por completo con la mostaza Dijon.\n\nEnfriar: Coloca el filete sobre una rejilla y d├®jalo enfriar a temperatura ambiente. Luego, ll├®valo al refrigerador por al menos 30 minutos. Debe estar completamente fr├¡o.\n\nFase 2: El Duxelles (Hacer mientras el filete se enfr├¡a)\nProcesar: Pon los champi├▒ones, chalotas, ajo y tomillo en un procesador de alimentos. Pulsa hasta que tengas una pasta muy fina.\n\nSecar (Paso Cr├¡tico): Pon la mantequilla en un sart├®n a fuego medio-alto. Agrega la pasta de champi├▒ones y una pizca de sal.\n\nCocina, revolviendo constantemente, durante 10-15 minutos. La mezcla soltar├í mucha agua. Sigue cocinando hasta que toda el agua se haya evaporado y tengas una pasta oscura y densa que se separa del sart├®n.\n\nEnfriar: Extiende el duxelles en un plato y d├®jalo enfriar completamente (puedes meterlo al refrigerador). Si est├í caliente, arruinar├í la masa.\n\nFase 3: El Pre-armado (La chaqueta de Prosciutto)\nLa Cama: Extiende una pieza grande de film pl├ístico (alusa plast) sobre tu mesa de trabajo.\n\nArmar: Superp├│n las l├íminas de prosciutto sobre el pl├ístico, creando un rect├íngulo que sea lo suficientemente grande como para envolver todo el filete.\n\nLa Capa: Con una esp├ítula, extiende el duxelles fr├¡o en una capa fina y uniforme sobre el prosciutto.\n\nEnrollar: Coloca el filete fr├¡o en el borde inferior del rect├íngulo. Usando el film pl├ístico para ayudarte, enrolla el prosciutto y el duxelles firmemente alrededor del filete, como si fuera un sushi.\n\nSellar: Gira las puntas del film pl├ístico (como un dulce) para apretar el rollo y que quede muy compacto.\n\nRefrigerar: Lleva este "paquete" al refrigerador por al menos 30 minutos (o incluso de un d├¡a para otro). Esto le da su forma cil├¡ndrica perfecta.\n\nFase 4: Armado Final y Horneado\nPrecalentar: Precalienta tu horno a 200┬░C (400┬░F) y prepara una bandeja de horno con papel mantequilla.\n\nLa Masa: Extiende la masa de hojaldre fr├¡a sobre una superficie ligeramente enharinada (o sobre un nuevo trozo de film pl├ístico).\n\nEnvolver: Saca el filete del film pl├ístico y ponlo en el centro de la masa.\n\nSellar: Pinta los bordes de la masa con el huevo batido. Envuelve la masa alrededor del filete, cortando cualquier exceso grande de masa (especialmente en las puntas). Pellizca las uniones para sellarlas muy bien.\n\nPosici├│n: Coloca el Wellington en la bandeja de horno con la uni├│n de la masa hacia abajo.\n\nGlasear y Decorar: Pinta toda la superficie con el huevo batido. Si lo deseas, puedes hacer cortes superficiales y decorativos (como un enrejado) con la punta de un cuchillo (┬ícon cuidado de no cortar la masa!). Espolvorea con sal gruesa.\n\n(Opcional pero recomendado): Refrigera el Wellington completo por 15 minutos m├ís antes de hornear.\n\nHorneado y Reposo (El Final)\nHorneado: Hornea a 200┬░C (400┬░F) durante 20-25 minutos. La masa debe estar dorada e inflada.\n\nBajar Temperatura: Baja el horno a 180┬░C (350┬░F) y hornea por 10-15 minutos m├ís.\n\nTemperatura Interna (La ├║nica forma de saber):\n\nPunto Rojo (Inglesa/Rare): 48-50┬░C (120┬░F)\n\nPunto Medio-Rojo (Medium-Rare): 52-54┬░C (125-130┬░F) - Este es el punto recomendado.\n\nA Punto (Medium): 57-60┬░C (135-140┬░F)\n\n┬íREPOSO OBLIGATORIO!: Saca el Wellington del horno y col├│calo en una tabla de cortar. D├®jalo reposar sin tapar durante 10 a 15 minutos. Si lo cortas de inmediato, todos los jugos se escapar├ín y arruinar├ís el plato. El reposo es vital.\n\nCortar: Usa un cuchillo de sierra (cuchillo de pan) para cortar rodajas gruesas y servir inmediatamente.	1	20	90	2023-06-27	1	0
12	Pastel de Pescado	https://www.themealdb.com/images/media/meals/ysxwuq1487323065.jpg		Fase 1: Preparar los Componentes\n\nHacer el Pur├®: Pela las papas, c├│rtalas en cubos iguales y ponlas en una olla con agua fr├¡a y sal. Ll├®valas a ebullici├│n y coc├¡nalas hasta que est├®n muy tiernas (15-20 minutos).\n\nPochar el Pescado (El Secreto del Sabor): Mientras las papas hierven, calienta la leche, la hoja de laurel y los granos de pimienta en un sart├®n grande a fuego medio. Justo antes de que hierva, baja el fuego.\n\nAgrega los trozos de pescado (blanco y ahumado) a la leche caliente. Cocina a fuego muy bajo (sin hervir) durante 5-7 minutos, o hasta que el pescado est├® casi cocido.\n\nCon una espumadera, saca con cuidado el pescado y ponlo en una fuente o plato. ┬íGuarda esa leche! Cuela la leche (para sacar el laurel y la pimienta) y res├®rvala.\n\nTerminar el Pur├®: Cuela las papas y devu├®lvelas a la olla caliente (sin agua) por 1 minuto para que se evapore el exceso de humedad. Mu├®lelas bien. Agrega la mantequilla, la leche tibia, sal y pimienta blanca. Bate hasta que est├® cremoso y res├®rvalo.\n\nFase 2: Hacer la Salsa y el Relleno\n\nSofre├¡r la Base: En una olla mediana, derrite 3 cucharadas de mantequilla a fuego medio. Agrega el puerro (o cebolla) y sofr├¡e por 5-8 minutos hasta que est├® muy blando, pero sin dorarse.\n\nHacer el Roux: Agrega las 3 cucharadas de harina al puerro y revuelve constantemente durante 1-2 minutos. Esto cocina la harina cruda.\n\nHacer la Salsa (Bechamel): Retira la olla del fuego. Agrega un chorrito de la leche que reservaste (donde cociste el pescado) y bate vigorosamente hasta que se integre.\n\nVuelve al fuego bajo y sigue agregando la leche de a poco, batiendo sin parar para que no se formen grumos.\n\nUna vez que toda la leche est├® incorporada, sube el fuego a medio y sigue batiendo hasta que la salsa hierva y espese. Sazona con sal, pimienta y la pizca de nuez moscada.\n\nFase 3: Armado y Horneado\n\nPrecalentar: Precalienta el horno a 190┬░C (375┬░F).\n\nCombinar el Relleno: Toma una fuente apta para horno (fuente de pyrex o greda).\n\nDesmenuza el pescado cocido en trozos grandes (no lo muelas). Agr├®galo a la fuente.\n\nA├▒ade los camarones crudos, las arvejas congeladas, el perejil picado y los huevos duros (si usas).\n\nVierte la salsa blanca (bechamel) caliente sobre toda la mezcla de pescado y revuelve suavemente para combinar.\n\nLa Cubierta: Cubre todo el relleno con el pur├® de papas, esparci├®ndolo con una cuchara desde los bordes hacia el centro (para sellar).\n\nCon un tenedor, "raspa" la superficie del pur├® para crear textura (esas puntas se dorar├ín maravillosamente).\n\nGratinar (Opcional): Espolvorea el queso parmesano o cheddar sobre el pur├®.\n\nHornear: Coloca la fuente sobre una bandeja de horno (por si burbujea y se derrama). Hornea por 30-40 minutos, o hasta que el pur├® est├® dorado y el relleno est├® burbujeando caliente por los bordes.\n\nDeja reposar 10 minutos antes de servir. Es un plato completo en s├¡ mismo.	1	28	90	2023-06-27	1	0
13	Sopa Crema de Tomate	https://www.themealdb.com/images/media/meals/stpuws1511191310.jpg		El Sofrito (Base del Sabor): En una olla grande o "Dutch oven" a fuego medio, derrite la mantequilla junto con el aceite de oliva (el aceite evita que la mantequilla se queme).\n\nAgrega la cebolla picada y la zanahoria (si la usas). Sofr├¡e lentamente durante 8-10 minutos, revolviendo ocasionalmente, hasta que est├®n muy blandas y la cebolla est├® trasl├║cida.\n\nA├▒ade el ajo picado y el or├®gano seco (si usas albahaca fresca, gu├írdala para el final). Cocina por 1 minuto m├ís, solo hasta que el ajo suelte su aroma.\n\nConstruir la Sopa: Agrega la lata de tomates enteros (con todo su jugo) y el caldo de verduras. Usa una cuchara de madera para romper los tomates grandes.\n\nA├▒ade la cucharadita de az├║car, una buena pizca de sal y pimienta negra.\n\nHervor Lento: Lleva la sopa a ebullici├│n, luego baja el fuego, tapa la olla y deja que hierva suavemente (simmer) durante al menos 20 minutos (30 minutos es a├║n mejor). Esto permite que todos los sabores se conozcan y se profundicen.\n\nLicuar (El Paso Clave): Aqu├¡ es donde se crea la magia cremosa.\n\nOpci├│n A (Ideal): Usa una licuadora de inmersi├│n (minipimer) directamente en la olla. Lic├║a hasta que la sopa est├® completamente suave y sedosa.\n\nOpci├│n B (Con cuidado): Transfiere la sopa en tandas a una licuadora de vaso. ┬íCon mucho cuidado! El vapor caliente puede ser peligroso. Lic├║a hasta que est├® suave y devuelve todo a la olla.\n\nTerminar con la Crema: Pon la olla de nuevo a fuego bajo. Vierte la crema de leche y revuelve. (Si usas albahaca fresca, a├▒├ídela ahora).\n\nCalienta la sopa suavemente por 5 minutos m├ís. No dejes que vuelva a hervir despu├®s de agregar la crema.\n\nAjustar: Prueba la sopa. ┬┐Necesita m├ís sal? ┬┐Un poco m├ís de pimienta? Aj├║stala a tu gusto.\n\nS├¡rvela bien caliente, idealmente junto a un s├índwich de queso derretido para la experiencia completa.\n\nVariaci├│n (Sabor Ahumado): Si quieres un sabor m├ís profundo, puedes usar tomates frescos (tipo Roma) y asarlos en el horno junto con la cebolla y el ajo antes de ponerlos en la olla.	1	30	90	2023-06-27	1	0
14	Pastel de Pavo Jugoso	https://www.themealdb.com/images/media/meals/ypuxtw1511297463.jpg		El Secreto de la Humedad (Sofrito): Este es el paso m├ís importante. Calienta el aceite de oliva en un sart├®n a fuego medio. Agrega la cebolla, el apio y la zanahoria rallada.\n\nSofr├¡e durante 8-10 minutos, revolviendo, hasta que las verduras est├®n muy blandas y la cebolla est├® trasl├║cida. Agrega el ajo y cocina por 1 minuto m├ís.\n\nRetira del fuego y deja que esta mezcla de verduras se enfr├¡e por completo. (No la agregues caliente a la carne cruda).\n\nPrecalentar: Precalienta el horno a 180┬░C (350┬░F). Prepara una bandeja de horno forrada con papel de aluminio o papel mantequilla.\n\nHacer la "Panade" (El 2do Secreto): En un bol muy grande, mezcla el pan rallado y la leche. Deja que repose 5 minutos para que el pan absorba el l├¡quido. Esto garantiza un pastel de carne tierno.\n\nCombinar (Sin Sobre-mezclar): Al bol grande con la "panade", agrega el pavo molido, la mezcla de verduras fr├¡a, los huevos batidos, las 2 cucharadas de salsa inglesa, las 2 cucharadas de ketchup, el perejil, la sal, la pimienta y el tomillo (si usas).\n\nUsando tus manos (es la mejor forma), mezcla todo suavemente solo hasta que est├® combinado. No lo amases ni lo sobre-mezcles, o el pastel quedar├í denso y duro.\n\nFormar el Pastel: Vuelca la mezcla en la bandeja de horno preparada y dale forma de un "pan" ovalado (aproximadamente 25 cm de largo y 12 cm de ancho).\n\nPreparar el Glaseado: En un bol peque├▒o, bate todos los ingredientes del glaseado (ketchup, az├║car rubia, vinagre y salsa inglesa) hasta que est├®n bien combinados.\n\nHornear (en dos etapas):\n\nEtapa 1: Unta la mitad del glaseado sobre la parte superior y los lados del pastel de pavo.\n\nHornea durante 40 minutos.\n\nEtapa 2: Saca el pastel del horno y unta con cuidado el resto del glaseado por encima.\n\nVuelve a hornear por 15 a 20 minutos m├ís.\n\nVerificar Cocci├│n: El pastel de carne est├í listo cuando el glaseado est├® caramelizado y burbujeante, y un term├│metro de carne insertado en el centro marque 74┬░C (165┬░F). (El pavo debe estar completamente cocido).\n\n┬íReposo Obligatorio!: Saca el pastel del horno y d├®jalo reposar en la bandeja durante 10 minutos antes de cortarlo en rodajas. Esto permite que los jugos se reabsorban y evita que se desarme.\n\nS├¡rvelo caliente. Combina perfectamente con pur├® de papas y porotos verdes (jud├¡as verdes).	1	25	90	2023-06-27	1	0
15	Bud├¡n Cremoso de Arroz y Br├│coli	https://www.themealdb.com/images/media/meals/vptwyt1511450962.jpg		Preparar los Componentes:\n\nArroz: Cocina el arroz como lo har├¡as normalmente (1 taza de arroz por 2 de agua) y res├®rvalo.\n\nHorno: Precalienta el horno a 180┬░C (350┬░F) y enmantequilla una fuente o Pyrex grande.\n\nBr├│coli: Blanquea el br├│coli. Pon los floretes en agua hirviendo con sal por solo 2-3 minutos. Esc├║rrelos inmediatamente y p├ísalos por agua fr├¡a para detener la cocci├│n (as├¡ queda verde brillante y tierno).\n\nEl Sofrito: En un sart├®n, calienta el aceite de oliva a fuego medio. A├▒ade la cebolla y la zanahoria rallada. Sofr├¡e por 8-10 minutos hasta que est├®n muy blandas y dulces.\n\nHacer la Salsa de Queso (Mornay):\n\nEn una olla mediana a fuego medio, derrite las 3 cucharadas de mantequilla.\n\nAgrega la harina y revuelve constantemente por 1 minuto (esto es un roux).\n\nVierte la leche de a poco, batiendo vigorosamente para que no se formen grumos.\n\nSigue batiendo a fuego medio hasta que la salsa hierva suavemente y espese (debe cubrir la parte de atr├ís de una cuchara).\n\nBaja el fuego al m├¡nimo. Agrega la mostaza, nuez moscada, sal y pimienta.\n\nA├▒ade 1 ┬¢ tazas del queso cheddar rallado (reserva la otra ┬¢ taza) y revuelve solo hasta que se derrita. Retira del fuego.\n\nCombinar Todo:\n\nEn un bol muy grande, pon el arroz cocido, el br├│coli blanqueado y el sofrito de cebolla/zanahoria.\n\nVierte la salsa de queso caliente sobre la mezcla.\n\nRevuelve suavemente con una esp├ítula hasta que todo est├® bien combinado. Prueba y ajusta la sal si es necesario.\n\nArmar y Hornear:\n\nVierte toda la mezcla en la fuente para horno que preparaste y esp├írcela de forma pareja.\n\nEn un bol peque├▒o, mezcla el pan rallado (Panko), la mantequilla derretida y el queso parmesano (si usas).\n\nEspolvorea la mezcla de pan rallado y el queso cheddar restante (la ┬¢ taza que guardaste) sobre la superficie.\n\nHornea por 25 a 30 minutos, o hasta que est├® burbujeante por los bordes y la cubierta est├® dorada y crujiente.\n\nDeja reposar 10 minutos antes de servir. ┬íEs un plato principal completo y delicioso!	1	32	90	2023-06-27	1	0
19	tapapecho curado a la Montreal 	https://www.themealdb.com/images/media/meals/uttupv1511815050.jpg		Desalinado (┬íPaso Cr├¡tico!):\n\nSaca el tapapecho del envase y descarta la salmuera (y la bolsita de especias que a veces trae).\n\nColoca la carne en una olla o contenedor grande y c├║brela completamente con agua fr├¡a.\n\nRefrig├®rala y d├®jala remojar por al menos 8 horas (idealmente 12-24 horas), cambiando el agua 2 o 3 veces.\n\n┬┐Por qu├®?: El corned beef est├í dise├▒ado para hervirse, por lo que es extremadamente salado. Si no lo desalas, quedar├í incomible despu├®s de ahumarlo.\n\nPreparar el Rub:\n\nEn un sart├®n seco a fuego medio, tuesta ligeramente los granos de pimienta y las semillas de coriandro (2-3 minutos, hasta que suelten su aroma).\n\nMuele las especias tostadas en un moledor de especias o en un mortero. No busques un polvo fino; quieres una molienda gruesa y r├║stica.\n\nMezcla esta molienda con el resto de los ingredientes del rub (paprika, ajo, cebolla).\n\nAplicar el Rub:\n\nSaca la carne del agua y s├®cala muy bien con toalla de papel.\n\nUnta toda la superficie de la carne con una capa fina de mostaza amarilla (esto solo ayuda a que el rub se pegue).\n\nAplica el rub generosamente por todos lados, presionando para que se adhiera.\n\nEl Ahumado (Fase 1):\n\nPrecalienta tu ahumador (smoker) o parrilla para cocci├│n indirecta a 135┬░C (275┬░F).\n\nColoca la carne en el ahumador. Ah├║ma durante 4 a 5 horas.\n\nLo que buscas es que la carne alcance una temperatura interna de 70┬░C (160┬░F) y haya desarrollado una costra oscura (el bark).\n\nEl Vapor (Fase 2 - El Secreto):\n\nTransfiere la carne ahumada a una bandeja de aluminio.\n\nAgrega 1 taza de l├¡quido a la bandeja (puede ser caldo de vacuno, cerveza o simplemente agua).\n\nCubre la bandeja herm├®ticamente con papel de aluminio.\n\nVuelve a poner la bandeja en el ahumador (o en un horno convencional, ya no necesita humo).\n\nSigue cocinando hasta que la temperatura interna de la carne alcance los 95┬░C (203┬░F). La carne debe estar "probe tender" (un term├│metro debe entrar y salir sin ninguna resistencia, como si fuera mantequilla). Esto puede tomar 3-4 horas adicionales.\n\nEl Reposo:\n\nSaca la bandeja del ahumador/horno y deja reposar la carne (a├║n envuelta) durante al menos 1 hora. Esto es vital para que los jugos se redistribuyan.\n\nC├│mo Servir (El Ritual)\nLa "Montreal Smoked Meat" no se sirve como un asado cualquiera.\n\nEl Corte: Se corta en contra de la veta de la carne. A diferencia del brisket texano, el corte de Montreal es tradicionalmente m├ís grueso (aprox. 0.5 cm).\n\nEl S├índwich: Se sirve apilado rid├¡culamente alto sobre pan de centeno (rye bread).\n\nEl ├ÜNICO Aderezo: Mostaza amarilla. Nada m├ís. (Quiz├ís un pepinillo dill al lado).\n\nEs un proyecto de todo un d├¡a, ┬ípero el resultado es una de las mejores carnes que probar├ís en tu vida!	1	20	91	2023-06-27	1	0
20	Timbits	https://www.themealdb.com/images/media/meals/txsupu1511815755.jpg		Preparar el Aceite: En una olla grande y pesada (idealmente de hierro fundido o un "Dutch oven"), vierte el aceite (debe tener al menos 5 cm de profundidad). Cali├®ntalo a fuego medio hasta que alcance 180┬░C (360┬░F). Usa un term├│metro de cocina; la temperatura es clave.\n\nPreparar los Secos: En un bol grande, mezcla la harina, az├║car, polvos de hornear, nuez moscada y sal.\n\nPreparar los H├║medos: En un bol mediano, bate los huevos. Luego agrega la mantequilla derretida, el buttermilk (o tu sustituto) y la vainilla. Bate hasta combinar.\n\nCombinar (┬íNo sobre-mezcles!): Vierte los ingredientes h├║medos sobre los secos. Usa una esp├ítula para mezclar justo hasta que est├®n combinados. La masa ser├í espesa y pegajosa, similar a una masa de queque denso. ┬íNo la batas!\n\nFormar los Timbits: La forma m├ís f├ícil es usar dos cucharas peque├▒as (cucharas de t├®). Toma una cucharada de masa con una y usa la otra para empujarla y redondearla un poco antes de dejarla caer con cuidado en el aceite caliente.\n\nFre├¡r en TANDAS:\n\nFr├¡e solo 6-8 bolitas a la vez (si pones muchas, el aceite se enfriar├í y quedar├ín aceitosas).\n\nSe inflar├ín y flotar├ín. Fr├¡e durante 2-3 minutos por lado. A menudo se dan vuelta solas, pero ay├║dalas si es necesario.\n\nDeben quedar de un color dorado oscuro y profundo.\n\nEscurrir: Usa una espumadera para sacar los Timbits del aceite y ponlos sobre una rejilla o plato con toallas de papel absorbente.\n\n┬íCubrir en Caliente! (El Secreto):\n\nDeja que se enfr├¡en solo por 1 minuto (deben seguir calientes, pero no hirviendo).\n\nPara Canela: Pasa las bolitas calientes por la mezcla de az├║car y canela.\n\nPara Glaseado: Sumerge cada bolita caliente en el glaseado y ponla en una rejilla para que el exceso escurra.\n\nS├¡rvelos lo antes posible. ┬íSon mucho mejores tibios!	1	22	91	2023-06-27	1	0
21	Pastel de Papas de Qu├®bec	https://www.themealdb.com/images/media/meals/yyrrxr1511816289.jpg		Preparar el Pur├®:\n\nPon las papas en cubos en una olla con agua fr├¡a y sal. Ll├®valas a ebullici├│n y coc├¡nalas hasta que est├®n muy tiernas (15-20 minutos).\n\nEsc├║rrelas bien y devu├®lvelas a la olla caliente por 1 minuto para que se evapore el exceso de humedad.\n\nMu├®lelas bien. Agrega la mantequilla, la leche tibia, sal y pimienta. Bate hasta que est├® cremoso y suave. Reserva.\n\nPreparar la Carne:\n\nPrecalienta el horno a 180┬░C (350┬░F).\n\nEn un sart├®n grande a fuego medio-alto, calienta el aceite o la mantequilla.\n\nAgrega la cebolla picada y sofr├¡e por 5 minutos hasta que est├® blanda.\n\nA├▒ade la carne molida. Cocina, desmenuz├índola con una cuchara, hasta que est├® completamente dorada.\n\nSazona con sal, pimienta y (si usas) el ketchup o salsa inglesa. Escurre el exceso de grasa.\n\nArmar el Pastel (El Orden es Clave):\n\nBusca una fuente para horno (Pyrex o similar) de tama├▒o mediano (aprox. 20x30 cm).\n\nCapa 1 (Abajo): Extiende toda la mezcla de carne cocida en el fondo de la fuente y presiona ligeramente para compactar.\n\nCapa 2 (Medio): Vierte la lata de choclo en crema y esp├írcela uniformemente sobre la carne. (Si usas choclo en grano extra, m├®zclalo con el choclo en crema primero).\n\nCapa 3 (Arriba): Con cuidado, pon el pur├® de papas sobre la capa de choclo. Exti├®ndelo suavemente con una esp├ítula para cubrir todo y sellar los bordes.\n\nAcabado: Con un tenedor, "raspa" la superficie del pur├® para crear crestas (esto las pondr├í crujientes). Espolvorea con piment├│n (paprika) y, si lo deseas, pon los cubitos de mantequilla extra encima.\n\nHornear:\n\nHornea durante 30-35 minutos. El objetivo es que se caliente por completo y que el pur├® se dore ligeramente por encima.\n\nSi la parte de arriba no est├í dorada, puedes ponerla bajo el "grill" (gratinador) del horno durante los ├║ltimos 2-3 minutos (┬ívigilando que no se queme!).\n\nServir:\n\nDeja reposar 10 minutos antes de servir.\n\n┬┐El toque final y 100% aut├®ntico de Qu├®bec? Se sirve directamente en el plato y se acompa├▒a con... ┬íKetchup!	1	20	91	2023-06-27	1	0
23	Papas de Desayuno Crujientes	https://www.themealdb.com/images/media/meals/yrstur1511816601.jpg		El Secreto (Doble Cocci├│n):\n\nM├®todo A (Hervido - Tradicional): Lava las papas y c├│rtalas en cubos de 1.5 cm (aprox.). Ponlas en una olla con agua fr├¡a y sal. Hi├®rvelas solo hasta que est├®n casi tiernas (unos 7-10 minutos). Deben estar firmes, si las pinchas, el tenedor debe encontrar resistencia.\n\nM├®todo B (Microondas - R├ípido): Pon los cubos de papa en un bol apto para microondas con 2 cucharadas de agua. Tapa y cocina a alta potencia por 4-5 minutos.\n\nPaso Cr├¡tico: Sea cual sea el m├®todo, escurre muy bien las papas y s├®calas con toalla de papel. Si est├ín h├║medas, se cocinar├ín al vapor en el sart├®n en vez de fre├¡rse.\n\nCalentar el Sart├®n: En un sart├®n grande (idealmente de hierro fundido o acero inoxidable) a fuego medio-alto, calienta el aceite y la mantequilla juntos.\n\nFre├¡r las Papas (Paciencia):\n\nAgrega las papas secas al sart├®n caliente. Esp├írcelas en una sola capa.\n\n┬íNo las muevas! D├®jalas fre├¡r sin tocarlas durante 4-5 minutos. Esto es esencial para que formen la costra dorada.\n\nVolt├®alas con una esp├ítula y d├®jalas quietas por otros 4-5 minutos. Repite hasta que est├®n doradas y crujientes por todos lados.\n\nA├▒adir los Vegetales: Cuando las papas est├®n casi listas (80% doradas), agrega la cebolla y el piment├│n picados.\n\nSazonar: Agrega la sal, la pimienta, el piment├│n (paprika) y el ajo en polvo. Revuelve todo junto y cocina por 4-5 minutos m├ís, hasta que las verduras est├®n tiernas y las papas completamente crujientes.\n\nServir: Retira del fuego, espolvorea con perejil fresco y sirve inmediatamente.\n\nVariaci├│n "Diner Style": Si te gustan m├ís blandas (estilo diner), simplemente pica las papas crudas y coc├¡nalas en el sart├®n tapado a fuego medio-bajo durante 15 minutos (para que se cuezan al vapor), y luego destapa, sube el fuego y a├▒ade las verduras para dorar.	1	19	91	2023-06-27	1	0
25	Tortilla de Patatas Espa├▒ola	https://www.themealdb.com/images/media/meals/quuxsx1511476154.jpg		La receta tiene 3 fases: la cocci├│n de las papas, el reposo con el huevo y el cuajado (la parte m├ís r├ípida).\n\nFase 1: El Confitado (La Paciencia)\n\nPelar y Cortar: Pela las papas. El corte tradicional es en "lascas" o l├íminas finas e irregulares, no en cubos perfectos. Corta la cebolla en juliana fina.\n\nLa Sart├®n: Pon el sart├®n a fuego medio con una cantidad generosa de aceite de oliva (debe ser suficiente para cubrir las papas).\n\nCocci├│n Lenta (El Secreto): Cuando el aceite est├® caliente (pero no humeando), a├▒ade las papas y la cebolla. Espolvorea un poco de sal.\n\nBaja el fuego a medio-bajo. La clave aqu├¡ es confitar, no fre├¡r. Las papas deben cocerse lentamente en el aceite, revolviendo de vez en cuando con cuidado para que no se peguen, durante unos 20-25 minutos.\n\nEstar├ín listas cuando, al pinchar una papa con la esp├ítula, se rompa f├ícilmente. No deben estar doradas, sino tiernas y blandas.\n\nFase 2: El Reposo (El Sabor)\n\nEscurrir: Coloca un colador grande sobre un bol. Vierte con cuidado el contenido del sart├®n (papas, cebolla y aceite) sobre el colador. Deja que escurra muy bien todo el aceite (este aceite puedes guardarlo, tiene un sabor incre├¡ble para futuras preparaciones).\n\nBatir Huevos: Mientras se escurren, bate los 6 huevos en un bol grande. A├▒ade una buena pizca de sal.\n\nLa Mezcla: A├▒ade las papas y cebollas (ya escurridas y a├║n tibias) al bol con los huevos batidos.\n\n┬íEl Reposo M├ígico!: Este es el truco para una tortilla jugosa. Deja que la mezcla de papa y huevo repose junta durante al menos 15 minutos (idealmente 30). Las papas absorber├ín el huevo y el almid├│n espesar├í la mezcla.\n\nFase 3: El Cuajado y "El Volteo" (La T├®cnica)\n\nCalentar el Sart├®n: Limpia el sart├®n donde confitaste las papas. Ponlo a fuego medio-alto con solo una cucharadita del aceite que escurriste.\n\nVerter: Cuando el sart├®n est├® bien caliente, vierte toda la mezcla del bol. Usa la esp├ítula para esparcirla uniformemente y "sellar" los bordes, empuj├índolos ligeramente hacia adentro.\n\nCuajar (Lado 1): Baja el fuego a medio-bajo. Cocina durante 3-4 minutos. Mueve el sart├®n en c├¡rculos peque├▒os para evitar que se pegue el centro.\n\nEl Volteo (El Momento de la Verdad):\n\nToma el plato llano grande y ponlo boca abajo sobre el sart├®n, como si fuera una tapa.\n\nSujeta el mango del sart├®n con una mano y presiona el plato firmemente contra el sart├®n con la otra.\n\nCon un movimiento r├ípido, seguro y fluido, gira el sart├®n 180 grados sobre el plato (hazlo sobre el lavaplatos si es tu primera vez, por si acaso).\n\nLa tortilla caer├í sobre el plato, con el lado cocido hacia arriba.\n\nCuajar (Lado 2): Desliza la tortilla suavemente desde el plato de vuelta al sart├®n (con el lado crudo hacia abajo).\n\nVuelve a usar la esp├ítula para redondear los bordes y darle su forma cl├ísica.\n\nCocina por 2-3 minutos m├ís (si te gusta muy jugosa) o 4-5 minutos (si la prefieres m├ís cuajada).\n\nD├®jala reposar 5 minutos en el plato antes de cortar. ┬íSe disfruta caliente, tibia o incluso fr├¡a al d├¡a siguiente!	1	32	92	2023-06-27	1	0
26	Paella de Hinojo y Berenjena Asados	https://www.themealdb.com/images/media/meals/1520081754.jpg		Necesitar├ís una paellera o un sart├®n muy grande y ancho (de unos 35-40 cm).\n\nAsar las Verduras (Fase 1):\n\nPrecalienta el horno a 200┬░C (400┬░F).\n\nEn una bandeja de horno, mezcla los cubos de berenjena y los gajos de hinojo con 3-4 cucharadas de aceite de oliva, sal y pimienta.\n\nExti├®ndelos en una sola capa.\n\nHornea durante 25-30 minutos, d├índoles la vuelta a mitad de camino, hasta que est├®n tiernos y bien caramelizados (dorados oscuros en los bordes). Res├®rvalos.\n\nPreparar el Caldo:\n\nEn una olla aparte, calienta el caldo de verduras. A├▒ade las hebras de azafr├ín y una pizca de sal.\n\nMantenlo caliente a fuego muy bajo (es crucial que el caldo est├® caliente al a├▒adirlo al arroz).\n\nEl Sofrito (Fase 2):\n\nColoca la paellera a fuego medio. A├▒ade las 4 cucharadas de aceite de oliva.\n\nSofr├¡e la cebolla y el piment├│n rojo. Cocina lentamente, revolviendo, durante 10-15 minutos hasta que est├®n muy blandos y dulces.\n\nA├▒ade el ajo picado y cocina 1 minuto m├ís.\n\nAgrega el tomate rallado y cocina por 5-8 minutos, hasta que el agua se evapore y se forme una pasta oscura.\n\n┬íImportante! Retira la paellera del fuego. A├▒ade el piment├│n ahumado (as├¡ no se quema) y revuelve bien.\n\nEl Arroz (Fase 3):\n\nVuelve a poner la paellera a fuego medio-alto. A├▒ade el arroz (en forma de cruz, seg├║n la tradici├│n, o simplemente esp├írcelo).\n\n"Nacara" el arroz: revu├®lvelo durante 1-2 minutos para que se impregne bien del aceite y el sofrito.\n\nLa Cocci├│n (┬íNo Revolver!):\n\nVierte todo el caldo caliente con azafr├ín sobre el arroz.\n\nRevuelve una sola vez para distribuir el arroz uniformemente por toda la paellera. A partir de este punto, no la revuelvas m├ís.\n\nCocina a fuego vivo (alto) durante los primeros 8-10 minutos.\n\nCuando el arroz empiece a asomar por la superficie del caldo, baja el fuego a medio-bajo.\n\nCocina por 10-12 minutos m├ís, hasta que el arroz haya absorbido casi todo el l├¡quido.\n\nEl Armado Final:\n\nCuando falten 5 minutos de cocci├│n, coloca las verduras asadas (el hinojo y la berenjena) por encima del arroz de forma decorativa.\n\nEl Socarrat (Opcional pero recomendado): Sube el fuego a alto durante el ├║ltimo minuto. Escucha con atenci├│n: oir├ís c├│mo el arroz del fondo empieza a "fre├¡rse" y oler├í a tostado. Ese es el socarrat (la costra crujiente del fondo). Retira del fuego justo antes de que se queme.\n\n┬íEl Reposo Obligatorio!:\n\nRetira la paellera del fuego. C├║brela con un pa├▒o de cocina limpio y seco (o papel de aluminio).\n\nDeja que repose durante 5 a 10 minutos antes de servir. Este paso es vital para que el arroz termine de cocerse con el vapor y los sabores se asienten.\n\nServir: Espolvorea con perejil fresco y lleva la paellera directamente a la mesa. Sirve con gajos de lim├│n al lado.	1	31	92	2023-06-27	1	0
27	Enchiladas de Pollo (Estilo Casserole)	https://www.themealdb.com/images/media/meals/qtuwxu1468233098.jpg		Precalentar y Preparar: Precalienta el horno a 180┬░C (350┬░F). Engrasa una fuente de horno grande (tama├▒o Pyrex de 9x13 pulgadas / 23x33 cm).\n\nEl Relleno Cremoso:\n\nEn un bol grande, mezcla el pollo deshebrado, los frijoles negros, el choclo, la cebolla picada (si usas) y la mitad (2 tazas) del queso rallado.\n\nAgrega el queso crema ablandado y 1 taza de la salsa de enchilada. Revuelve bien. Esta mezcla ser├í el relleno.\n\nEl Paso Clave (Evitar que se ponga blando):\n\nCalienta el aceite vegetal en un sart├®n a fuego medio-alto.\n\nPasa cada tortilla de ma├¡z por el aceite caliente, solo por 10-15 segundos por lado. No quieres que queden crujientes, solo que se "sellen" y queden flexibles.\n\nS├ícalas y d├®jalas escurrir en un plato con toallas de papel. Este paso evita que las tortillas se desintegren y absorban toda la salsa.\n\nEl Armado (Como una Lasa├▒a):\n\nCapa 1 (Base): Vierte ┬¢ taza de salsa de enchilada en el fondo de la fuente y esp├írcela (esto evita que se pegue).\n\nCapa 2 (Tortillas): Coloca una capa de tortillas fritas sobre la salsa, cubriendo el fondo. Puedes romperlas o superponerlas para que encajen.\n\nCapa 3 (Relleno): Esparce la mitad de la mezcla del relleno de pollo y frijoles sobre las tortillas.\n\nCapa 4 (Salsa): Vierte 1 taza de salsa de enchilada sobre el relleno.\n\nCapa 5 (Tortillas): Coloca otra capa de tortillas.\n\nCapa 6 (Relleno): Esparce la otra mitad del relleno.\n\nCapa 7 (Tortillas): Coloca la ├║ltima capa de tortillas por encima.\n\nCapa 8 (Final): Vierte toda la salsa restante sobre la parte superior, asegur├índote de que cubra todo.\n\nCapa 9 (Queso): Cubre generosamente con la otra mitad (2 tazas) de queso rallado.\n\nHornear:\n\nTapado: Cubre la fuente con papel de aluminio y hornea durante 25 minutos.\n\nDestapado: Retira el papel de aluminio y hornea por 10-15 minutos m├ís, o hasta que el queso est├® dorado, burbujeante y el pastel est├® caliente en el centro.\n\n┬íReposo Obligatorio!:\n\nSaca el pastel del horno y d├®jalo reposar sobre una rejilla durante 10-15 minutos. Al igual que la lasa├▒a, esto es vital para que los jugos se asienten y puedas cortar porciones limpias.\n\nServir: Corta en cuadrados y sirve caliente, decorado con crema agria, cilantro y palta.	1	21	93	2023-06-27	1	0
29	Chili de Carne de Vacuno Braseada	https://www.themealdb.com/images/media/meals/uuqvwu1504629254.jpg		Este plato requiere paciencia. El tiempo de cocci├│n es de 3 a 4 horas.\n\nPreparar la Carne (El Sabor):\n\nCorta la carne en cubos grandes (de unos 3-4 cm). Saz├│nalos generosamente con sal y pimienta.\n\nPasa los cubos por harina, sacudiendo el exceso.\n\nCalienta el aceite en una olla grande y de fondo grueso (idealmente de hierro fundido) a fuego alto.\n\nSella la carne en tandas. No sobrecargues la olla. Dora los cubos por todos lados hasta que tengan una costra marr├│n oscura. Retira la carne a un bol y reserva.\n\nEl Sofrito:\n\nEn la misma olla, baja el fuego a medio. Agrega un poco m├ís de aceite si es necesario.\n\nA├▒ade la cebolla, el piment├│n y el jalape├▒o (si usas). Sofr├¡e por 8-10 minutos, raspando el fondo para soltar los trozos dorados de la carne (fond), hasta que las verduras est├®n muy blandas.\n\nAgrega el ajo y la pasta de tomate. Cocina por 2 minutos m├ís, revolviendo constantemente.\n\nLas Especias (El "Bloom"):\n\nA├▒ade todas las especias secas (aj├¡ en polvo, comino, piment├│n ahumado, or├®gano). Revuelve todo por 1 minuto sin parar. Esto "despierta" las especias y es crucial para el sabor.\n\nDesglasar:\n\nVierte la cerveza negra para desglasar. Hierve fuerte por 2 minutos, raspando vigorosamente el fondo de la olla hasta que no quede nada pegado.\n\nEl Braseado (Cocci├│n Lenta):\n\nRegresa la carne (y todos sus jugos) a la olla.\n\nA├▒ade los tomates triturados, el caldo de vacuno, las hojas de laurel y el ingrediente secreto (cacao o chocolate).\n\nLleva a ebullici├│n, luego baja el fuego al m├¡nimo absoluto.\n\nCocci├│n: Tapa la olla y deja que hierva muy suavemente (simmer) durante 3 a 3.5 horas. (Alternativa: M├®telo a un horno precalentado a 160┬░C / 325┬░F por el mismo tiempo).\n\nEstar├í listo cuando la carne est├® tan tierna que puedas desmecharla f├ícilmente con un tenedor.\n\nTerminar el Chili:\n\nRetira las hojas de laurel. Puedes usar dos tenedores para desmechar la carne dentro de la misma olla, o dejar los trozos enteros si lo prefieres.\n\n(Opcional): Si vas a usar porotos negros, a├▒├ídelos ahora.\n\nEspesar: Si el chili est├í muy l├¡quido, agrega la mezcla de maicena/agua fr├¡a y revuelve. Deja hervir suavemente 5 minutos m├ís hasta que espese.\n\nAjustar Sabor: Agrega el chorrito de jugo de lim├│n o vinagre (esto balancea la riqueza del plato). Prueba y ajusta la sal.\n\nSirve el chili bien caliente en boles, cubierto generosamente con tus toppings favoritos (la crema agria y el queso son casi obligatorios).	1	20	93	2023-06-27	1	0
3	Panqueques de pl├ítano	https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg		Preparar ingredientes h├║medos: En un bol grande, muele muy bien los pl├ítanos maduros con un tenedor hasta hacerlos pur├®. Agrega el huevo, la leche, la mantequilla derretida y la vainilla. Bate hasta que est├® todo bien combinado.\n\nPreparar ingredientes secos: En un bol aparte, mezcla la harina, los polvos de hornear, la sal y (si usas) el az├║car y la canela.\n\nCombinar las mezclas: Vierte los ingredientes secos sobre el bol de los ingredientes h├║medos (el pl├ítano, leche, etc.).\n\nNo sobrebatir (El secreto): Mezcla con un batidor de mano o una esp├ítula solo hasta que se integren. Es normal y deseable que queden algunos grumos; si bates demasiado, los panqueques quedar├ín duros en lugar de esponjosos.\n\nCalentar el sart├®n: Calienta un sart├®n o plancha a fuego medio. Agrega un poco de mantequilla o aceite.\n\nCocinar: Vierte aproximadamente ┬╝ de taza de la mezcla por cada panqueque en el sart├®n caliente.\n\nDar vuelta: Cocina durante 2-3 minutos. Sabr├ís que es hora de voltear cuando veas burbujas que se forman y revientan en la superficie, y los bordes se vean dorados.\n\nTerminar: Voltea el panqueque con cuidado y cocina por 1-2 minutos m├ís por el otro lado, hasta que est├® dorado.\n\nServir: Repite con el resto de la masa (agregando m├ís mantequilla al sart├®n si es necesario) y sirve los panqueques calientes con tus acompa├▒amientos favoritos.	1	22	89	2023-06-27	1	0
4	Chocolate Caliente estilo Fudge	https://www.themealdb.com/images/media/meals/xrysxr1483568462.jpg		Hacer una "pasta": En un bol peque├▒o, mezcla la maicena, el cacao en polvo, el az├║car y la pizca de sal. Agrega 3-4 cucharadas de la leche (fr├¡a) y bate bien hasta formar una pasta suave y sin grumos.\n\nCalentar la leche: Calienta el resto de la leche en una olla a fuego medio, justo hasta que empiece a humear por los bordes (no dejes que hierva).\n\nAgregar el chocolate: Baja el fuego y agrega el chocolate troceado. Bate constantemente hasta que el chocolate est├® completamente derretido.\n\nEspesar: Sube un poco el fuego (a medio-bajo) y vierte la "pasta" de cacao y maicena que preparaste.\n\nBatir y cocinar: Sigue batiendo constantemente. La mezcla debe llegar a un hervor muy suave y cocinarse por 1-2 minutos. Notar├ís que espesa visiblemente, adquiriendo una textura similar a la de un postre.\n\nFinalizar: Retira del fuego, agrega la vainilla y sirve inmediatamente.	1	22	89	2023-06-27	1	0
31	Fajitas de Garbanzos	https://www.themealdb.com/images/media/meals/tvtxpq1511464705.jpg		Precalentar y Preparar: Precalienta el horno a 200┬░C (400┬░F). Prepara una bandeja de horno grande.\n\nSecar los Garbanzos (┬íImportante!): Despu├®s de enjuagar y escurrir los garbanzos, s├®calos muy bien con toallas de papel. Si est├ín h├║medos, se cocinar├ín al vapor en lugar de asarse.\n\nSazonar: En un bol grande, pon los garbanzos secos, las tiras de piment├│n y las tiras de cebolla.\n\nRoc├¡alos con las 3 cucharadas de aceite de oliva y espolvorea todo el sazonador de fajitas por encima. Revuelve muy bien con las manos o una esp├ítula hasta que todo est├® uniformemente cubierto.\n\nAsar (Roast): Extiende la mezcla en la bandeja del horno en una sola capa uniforme. (No amontones las verduras, o se cocer├ín al vapor. Usa dos bandejas si es necesario).\n\nHornea durante 20-25 minutos. Revu├®lvelas a mitad de camino (a los 10-12 minutos).\n\nEstar├ín listas cuando las verduras est├®n tiernas, los garbanzos est├®n ligeramente crujientes y todo tenga bordes tostados (carbonizados).\n\nEl Toque Final: Saca la bandeja del horno. Exprime inmediatamente el jugo de lim├│n sutil sobre todas las verduras y garbanzos calientes. (┬íEscuchar├ís el "sizzle"!).\n\nCalentar Tortillas: Mientras se asa la mezcla, calienta las tortillas en un comal, sart├®n o en el microondas.\n\nSirve todo al centro de la mesa (la bandeja de horno, las tortillas calientes y los acompa├▒amientos) y deja que cada persona arme sus propias fajitas.	1	32	93	2023-06-27	1	0
6	Pollo Frito Estilo "KFC"	https://www.themealdb.com/images/media/meals/xqusqy1487348868.jpg		Marinar (Paso Clave): En un bol grande, mezcla el buttermilk (o tu sustituto de leche y lim├│n), el huevo batido y la salsa picante. Sumerge todas las piezas de pollo, asegur├índote de que queden bien cubiertas. Tapa el bol y refrigera por un m├¡nimo de 4 horas (idealmente, d├®jalo de un d├¡a para otro). Esto ablanda la carne y la hace incre├¡blemente jugosa.\n\nPreparar la Harina Sazonada: En otro bol muy grande (o una bolsa de papel resistente), mezcla la harina, la maicena y TODAS las 11 hierbas y especias (del piment├│n hasta la sal de apio). Revuelve muy bien para que los condimentos se distribuyan de forma pareja.\n\nEl Doble Rebozado (El secreto de la costra):\n\nSaca una pieza de pollo de la marinada, dejando que el exceso de l├¡quido escurra un poco.\n\nP├ísala por la mezcla de harina sazonada, cubri├®ndola completamente.\n\n(Importante) Vuelve a sumergir la pieza de pollo r├ípidamente en la marinada de buttermilk.\n\nP├ísala por segunda vez por la harina sazonada. Presiona bien la harina contra el pollo para que se forme una costra gruesa.\n\nColoca la pieza enharinada sobre una rejilla.\n\nReposo: Repite el paso 3 con todas las piezas. Deja que el pollo repose sobre la rejilla durante 15-20 minutos. Esto ayuda a que la costra se "pegue" al pollo y no se caiga al fre├¡r.\n\nCalentar el Aceite: En una olla grande y pesada (idealmente de hierro fundido) o un sart├®n profundo, calienta el aceite hasta que alcance los 175┬░C (350┬░F). Es muy recomendable usar un term├│metro de cocina para esto.\n\nFre├¡r en TANDAS:\n\nCon cuidado, coloca 3 o 4 piezas de pollo en el aceite caliente. No sobrecargues la olla, ya que esto bajar├í la temperatura del aceite y el pollo quedar├í grasoso en vez de crujiente.\n\nFr├¡e el pollo, d├índolo vuelta ocasionalmente, hasta que est├® dorado oscuro y bien cocido por dentro.\n\nTiempos aproximados:\n\nAlas: 8-10 minutos.\n\nPechugas: 12-15 minutos.\n\nMuslos y Trutros (piernas): 15-18 minutos.\n\nConfirmaci├│n: La forma m├ís segura de saber es que la temperatura interna del pollo (lejos del hueso) alcance los 74┬░C (165┬░F).\n\nEscurrir: Saca el pollo del aceite y d├®jalo escurrir sobre una rejilla limpia (no sobre papel de cocina, ya que el vapor lo ablandar├í).\n\nSirve caliente. ┬íEl resultado es espectacular!	1	21	89	2023-06-27	1	0
7	Sloppy Joes de Cerdo a la Barbacoa	https://www.themealdb.com/images/media/meals/atd5sh1583188467.jpg		Sellar la Carne: Calienta el aceite en un sart├®n grande u olla a fuego medio-alto. Agrega la carne molida de cerdo y sep├írala con una cuchara de madera. Cocina hasta que se dore (unos 5-7 minutos).\n\nEl Sofrito: Agrega la cebolla picada y el piment├│n verde (si usas). Cocina todo junto por 5-8 minutos, hasta que la cebolla est├® blanda y transparente.\n\nArom├íticos: A├▒ade el ajo picado y cocina por 1 minuto m├ís, solo hasta que suelte su aroma (que no se queme).\n\nDrenar (Opcional): Si el cerdo solt├│ demasiada grasa, puedes inclinar el sart├®n y retirar el exceso con una cuchara, pero deja un poco para el sabor.\n\nConstruir la Salsa: Baja el fuego a medio-bajo. Agrega al sart├®n TODOS los ingredientes de la salsa: el ketchup, el az├║car rubia, el vinagre, la salsa inglesa, la mostaza, el piment├│n ahumado y el comino. Revuelve todo vigorosamente.\n\nHervor Lento (El Secreto): A├▒ade el caldo o agua (esto ayudar├í a que todo se integre) y revuelve bien. Deja que la mezcla hierva suavemente (a fuego bajo) y sin tapar, durante 15 a 20 minutos.\n\nEspesar: La salsa debe reducirse y espesar hasta tener una consistencia "descuidada" (sloppy), que se mantenga unida pero siga jugosa. Revuelve de vez en cuando.\n\nRectificar Sabor: Prueba la salsa. ┬┐Le falta sal? ┬┐Un poco m├ís de dulzor (az├║car) o acidez (vinagre)? Aj├║stala a tu gusto y sazona con pimienta negra.\n\nTostar los Panes: Mientras la salsa reposa, unta el interior de los panes de hamburguesa con mantequilla y tu├®stalos en un sart├®n o plancha hasta que est├®n dorados.\n\nServir: Sirve una porci├│n generosa de la mezcla de cerdo BBQ caliente sobre la base del pan.\n\nSugerencia de Oro: S├¡rvelo cubierto con una cucharada de ensalada Coleslaw (ensalada de repollo agridulce). El contraste del cerdo caliente y la ensalada fr├¡a y crujiente es la combinaci├│n perfecta.	1	27	89	2023-06-27	1	0
9	Berenjena Asada con Tahini, Pi├▒ones y Lentejas	https://www.themealdb.com/images/media/meals/ysqrus1487425681.jpg		Asar las Berenjenas (El Paso m├ís largo):\n\nPrecalienta el horno a 200┬░C (400┬░F).\n\nCorta las berenjenas por la mitad, a lo largo.\n\nCon un cuchillo, haz cortes diagonales en la pulpa de la berenjena (en forma de diamante), pero sin cortar la piel. Esto ayuda a que se cocine de manera uniforme.\n\nColoca las mitades de berenjena en una bandeja de horno, con la pulpa hacia arriba.\n\nRoc├¡alas generosamente con aceite de oliva, sal, pimienta y el piment├│n ahumado (si usas).\n\nHornea durante 35-45 minutos. Estar├ín listas cuando la pulpa est├® muy tierna (casi deshaci├®ndose) y los bordes est├®n caramelizados y dorados.\n\nCocinar las Lentejas (Mientras se hornea la berenjena):\n\nEnjuaga las lentejas.\n\nPonlas en una olla con el agua (o caldo) y la hoja de laurel.\n\nLleva a ebullici├│n, luego baja el fuego y cocina a fuego lento (semitapado) durante 20-25 minutos. Deben estar tiernas pero firmes, no deshechas (al dente).\n\nEscurre bien cualquier exceso de l├¡quido.\n\nEn un bol, ali├▒a las lentejas calientes con 1 cucharada de aceite de oliva, el jugo de lim├│n, el perejil picado, sal y pimienta. Reserva.\n\nHacer la Salsa de Tahini:\n\nEn un bol, mezcla el tahini, el jugo de lim├│n y el ajo picado. Al principio, la mezcla se pondr├í muy espesa (se "agarrotar├í").\n\nAgrega el agua fr├¡a, de a poco, mientras bates constantemente.\n\nSigue batiendo hasta que la salsa se vuelva p├ílida, suave y cremosa, con una consistencia similar al yogur l├¡quido o miel ligera. Ajusta con sal.\n\nTostar los Pi├▒ones:\n\nEn un sart├®n seco (sin aceite) a fuego medio-bajo, tuesta los pi├▒ones.\n\nMu├®velos constantemente durante 2-3 minutos. No les quites el ojo de encima, ya que pasan de dorados a quemados en segundos.\n\nEn cuanto tomen un color dorado y suelten aroma, ret├¡ralos del fuego inmediatamente.\n\nMontaje del Plato:\n\nColoca las mitades de berenjena asada en un plato grande o fuente (puedes aplastar ligeramente la pulpa con un tenedor si lo deseas).\n\nVierte una generosa cantidad de la salsa de tahini sobre cada mitad de berenjena.\n\nCubre con una porci├│n de las lentejas ali├▒adas.\n\nEspolvorea por encima los pi├▒ones tostados y las semillas de granada.\n\nTermina con las hojas de menta o perejil fresco y un ├║ltimo chorrito de aceite de oliva virgen extra.\n\nSe sirve tibio o a temperatura ambiente. ┬íEs un plato espectacular!	1	32	89	2023-06-27	1	0
16	Pie de Frutilla y Ruibarbo	https://www.themealdb.com/images/media/meals/178z5o1585514569.jpg		Preparar las Frutas: En un bol muy grande, combina las frutillas en cuartos y el ruibarbo en trozos.\n\nPreparar la Mezcla Seca: En un bol peque├▒o aparte, mezcla el az├║car, la maicena y la sal. (Mezclarlos antes de agregarlos a la fruta evita que la maicena se apelmace).\n\nCombinar el Relleno: Vierte la mezcla de az├║car/maicena sobre la fruta. Agrega el jugo de lim├│n y la vainilla. Revuelve suavemente con una esp├ítula hasta que toda la fruta est├® cubierta. Deja reposar 15 minutos mientras preparas la masa.\n\nPrecalentar y Preparar la Base:\n\nPrecalienta el horno a 200┬░C (400┬░F).\n\nColoca una bandeja de horno en la rejilla inferior del horno (esto ayudar├í a dorar la base y atrapar├í cualquier goteo).\n\nForra un molde para pie de 23 cm (9 pulgadas) con uno de los discos de masa.\n\nArmar el Pie:\n\nVierte todo el relleno (incluidos los jugos que se formaron) dentro de la base de masa.\n\nEsparce los cubitos de mantequilla fr├¡a sobre el relleno (esto a├▒ade riqueza).\n\nCubre el pie con el segundo disco de masa. Puedes hacerlo de dos maneras:\n\nTapa S├│lida: C├║brelo y haz 4-5 cortes en el centro para que escape el vapor.\n\nEnrejado (Lattice): Corta la masa en tiras y teje un enrejado (esta es la forma cl├ísica, ya que ayuda a evaporar m├ís l├¡quido).\n\nSellar: Pellizca los bordes de la masa superior e inferior para sellar bien el pie.\n\nTerminaci├│n: Barniza toda la superficie de la masa con el huevo batido (la egg wash). Espolvorea generosamente con el az├║car gruesa (esto le da un toque crujiente y profesional).\n\nHornear (El Paso Cr├¡tico):\n\nColoca el pie sobre la bandeja que precalentaste en la rejilla inferior del horno.\n\nHornea a 200┬░C (400┬░F) durante 20 minutos. (Este golpe de calor inicial ayuda a cocinar la masa inferior).\n\nBaja la temperatura a 180┬░C (350┬░F).\n\nHornea por 30-40 minutos m├ís.\n\n┬┐C├│mo saber si est├í listo?: El pie est├í listo cuando la masa est├® dorada oscura y, lo m├ís importante, el relleno est├® burbujeando vigorosamente en el centro. Si solo burbujea en los bordes, la maicena no se ha activado y el relleno quedar├í l├¡quido.\n\n┬íENFRIAR! (Paso Obligatorio):\n\nEste es el paso m├ís importante que la gente ignora. Saca el pie del horno y d├®jalo enfriar sobre una rejilla.\n\nDebe enfriarse por un m├¡nimo de 3 a 4 horas a temperatura ambiente.\n\nSi lo cortas caliente, el relleno ser├í una sopa. Durante el enfriamiento, la maicena hace su trabajo y el relleno se gelifica perfectamente.\n\nS├¡rvelo solo o, a├║n mejor, con una bola de helado de vainilla.	1	22	90	2023-06-27	1	0
17	Sopa de Arvejas Partidas y Jam├│n	https://www.themealdb.com/images/media/meals/xxtsvx1511814083.jpg		Enjuagar las Arvejas: Pon las arvejas partidas en un colador y enju├ígalas bien bajo el chorro de agua fr├¡a hasta que el agua salga clara. Revisa si hay alguna piedrecita y desc├írtala.\n\nPreparar la Base de Sabor:\n\nSi usas Codillo de Cerdo: Calienta el aceite de oliva en una olla grande o "Dutch oven" a fuego medio.\n\nSi usas Tocino: Pon el tocino picado en la olla fr├¡a y coc├¡nalo a fuego medio hasta que est├® crujiente y haya soltado su grasa. Retira el tocino con una espumadera y res├®rvalo (lo usar├ís para decorar). Deja la grasa en la olla.\n\nEl Sofrito (Mirepoix): Agrega la cebolla, las zanahorias y el apio a la olla (con el aceite o la grasa del tocino). Sofr├¡e durante 8-10 minutos, revolviendo, hasta que las verduras est├®n blandas y la cebolla trasl├║cida.\n\nAgrega el ajo picado y cocina por 1 minuto m├ís, hasta que suelte su aroma.\n\nArmar la Sopa: A├▒ade a la olla las arvejas partidas (enjuagadas), el caldo de pollo, las hojas de laurel y el tomillo.\n\nEl Cerdo: Si usas el codillo de cerdo, an├¡dalo en el centro de la sopa, asegur├índote de que est├® mayormente cubierto por el l├¡quido.\n\nHervor Lento (El Paso Clave): Lleva la sopa a ebullici├│n. Luego, baja el fuego de inmediato, tapa la olla parcialmente y deja que hierva muy suavemente (simmer) durante 1 a 1.5 horas.\n\nRevuelve cada 15-20 minutos, raspando el fondo para asegurarte de que las arvejas no se peguen.\n\nLa sopa est├í lista cuando las arvejas est├®n completamente deshechas y la sopa est├® espesa.\n\nDesmechar el Cerdo: Retira con cuidado el codillo de cerdo de la sopa (estar├í muy caliente) y ponlo en una tabla de cortar. Saca las hojas de laurel de la sopa y desc├írtalas.\n\nCuando el codillo est├® lo suficientemente fr├¡o para manipularlo, usa dos tenedores para desmechar la carne, descartando el hueso, el cuero y el exceso de grasa.\n\nTerminar la Sopa: Vuelve a poner toda la carne desmechada en la olla.\n\nTextura (Opcional):\n\nSi la prefieres r├║stica, la sopa est├í lista.\n\nSi la prefieres cremosa, usa una licuadora de inmersi├│n (minipimer) y dale solo unos pocos pulsos para espesar y cremar una parte, dejando a├║n trozos de vegetales (esta es mi forma favorita).\n\nSi la quieres totalmente suave, lic├║ala por completo.\n\nSazonar (Importante): Ahora es el momento de probar. El codillo y el caldo aportan mucha sal. Agrega abundante pimienta negra y prueba. A├▒ade sal solo si es necesario.\n\nServir: Sirve la sopa bien caliente. Si usaste tocino, decora con los trocitos crujientes que reservaste, crutones o un chorrito de aceite de oliva.	1	29	91	2023-06-27	1	0
18	Pastel de Carne	https://www.themealdb.com/images/media/meals/ytpstt1511814614.jpg		Fase 1: El Relleno (Debe hacerse con anticipaci├│n)\n\nCocinar la Carne: En una olla grande o sart├®n profundo a fuego medio-alto, derrite la mantequilla. Agrega el cerdo molido y el vacuno molido.\n\nCocina la carne, desmenuz├índola con una cuchara de madera, hasta que est├® dorada. Quieres que la textura quede fina, as├¡ que r├│mpela bien.\n\nEl Sofrito: Agrega la cebolla picada y el ajo. Cocina por 5-8 minutos m├ís, hasta que la cebolla est├® completamente blanda y trasl├║cida.\n\nA├▒adir Sabor: Escurre el exceso de grasa de la carne (si hay mucho). Agrega todas las especias (canela, nuez moscada, clavo, tomillo, salvia), junto con la sal y la pimienta. Revuelve y cocina por 1 minuto para tostar las especias.\n\nEl Aglutinante (Binding): Agrega la papa rallada fina y el caldo de vacuno. Revuelve todo muy bien.\n\nHervor Lento: Lleva la mezcla a ebullici├│n, luego baja el fuego al m├¡nimo. Deja que hierva suavemente (simmer), sin tapar, durante 30-45 minutos.\n\nEl objetivo es que el l├¡quido se evapore casi por completo y la papa se deshaga, creando un relleno espeso y unido, no l├¡quido.\n\n┬íENFRIAR! (Paso Cr├¡tico): Retira el relleno del fuego y vi├®rtelo en una fuente o bol. Deja que se enfr├¡e completamente a temperatura ambiente (o incluso refrig├®ralo). Si pones el relleno caliente en la masa, derretir├í la mantequilla de la masa y el fondo quedar├í remojado.\n\nFase 2: Armado y Horneado\n\nPrecalentar: Precalienta el horno a 200┬░C (400┬░F).\n\nBase: Forra un molde de pie de 23 cm (9 pulgadas) con uno de los discos de masa.\n\nRellenar: Vierte el relleno de carne fr├¡o dentro de la base y esp├írcelo de manera uniforme.\n\nTapa: Cubre el relleno con el segundo disco de masa. Sella los bordes pellizc├índolos (puedes usar un tenedor o hacer un repulgue).\n\nAcabado: Haz 4-5 cortes en la parte superior de la masa para que escape el vapor. (Opcional: puedes decorar con recortes de masa, como hojas).\n\nBarniza toda la superficie con el huevo batido.\n\nHornear:\n\nHornea a 200┬░C (400┬░F) durante 15 minutos.\n\nBaja la temperatura a 180┬░C (350┬░F) y contin├║a horneando por 30-40 minutos m├ís, o hasta que la masa est├® dorada oscura y el relleno est├® burbujeando por los cortes.\n\nReposo (Obligatorio): Saca el Tourti├¿re del horno y d├®jalo reposar sobre una rejilla durante al menos 20 minutos antes de cortarlo. Esto permite que el relleno se asiente.\n\nSe sirve tradicionalmente con un "fruit ketchup" (ketchup de frutas), "chow-chow" (un encurtido agridulce) o, m├ís com├║nmente, solo con ketchup regular.	1	27	91	2023-06-27	1	0
22	Pastel de Az├║car de Qu├®bec	https://www.themealdb.com/images/media/meals/yrstur1511816601.jpg		Precalentar y Preparar la Masa:\n\nPrecalienta el horno a 190┬░C (375┬░F).\n\nForra un molde de pie de 9 pulgadas (23 cm) con tu disco de masa. Pellizca o repulga los bordes. No es necesario pre-hornear la masa.\n\nPreparar el Relleno:\n\nEn un bol grande, combina el az├║car rubia compactada, la harina y la sal. B├ítelos bien con un batidor de mano para deshacer cualquier grumo de az├║car.\n\nEn un bol mediano, bate la crema de leche, la mantequilla derretida y la vainilla. (Si usas el sirope de maple, agr├®galo aqu├¡).\n\nVierte la mezcla de crema sobre la mezcla de az├║car.\n\nBate suavemente, solo hasta que todo est├® combinado y no queden grumos secos. No batas en exceso.\n\nLlenar y Hornear:\n\nVierte el relleno l├¡quido directamente sobre la base de masa cruda.\n\nColoca el molde de pie sobre una bandeja de horno (esto es para atrapar cualquier goteo accidental, ┬íte salvar├í el horno!).\n\nHornea a 190┬░C (375┬░F) durante 15 minutos. Este calor inicial ayuda a "sellar" la base de la masa.\n\nBajar la Temperatura:\n\nDespu├®s de 15 minutos, baja la temperatura del horno a 175┬░C (350┬░F).\n\nContin├║a horneando por 30 a 40 minutos m├ís.\n\nPrueba de Cocci├│n (┬íEl Paso Cr├¡tico!):\n\nEl pie estar├í listo cuando los bordes est├®n inflados y la superficie est├® dorada y burbujeante.\n\nEl centro (un c├¡rculo de unos 10 cm) debe seguir temblando visiblemente (como una jalea o un flan) cuando muevas el molde suavemente.\n\nSi esperas a que el centro est├® firme, lo habr├ís cocinado demasiado y la textura no ser├í la correcta.\n\nEnfriamiento Obligatorio (El Secreto Final):\n\nSaca el pie del horno y col├│calo en una rejilla.\n\nDebe enfriarse completamente a temperatura ambiente. Esto toma al menos 3 a 4 horas.\n\nDurante este tiempo, el relleno se asentar├í y tomar├í esa textura densa y perfecta de caramelo. Si lo cortas caliente, ser├í una sopa.\n\nS├¡rvelo a temperatura ambiente o fr├¡o, idealmente con una cucharada de crema batida sin az├║car para cortar el intenso dulzor.	1	22	91	2023-06-27	1	0
24	Paella de Fideos y Mariscos	https://www.themealdb.com/images/media/meals/wqqvyq1511179730.jpg		Necesitar├ís una paellera o un sart├®n muy grande, ancho y poco profundo.\n\nPreparar el Caldo y los Mariscos (Fase 1):\n\nCalienta el caldo de pescado en una olla. A├▒ade las hebras de azafr├ín, revuelve y mantenlo caliente a fuego bajo.\n\nEn un sart├®n aparte con un chorrito de aceite, cocina los mejillones y las almejas (puedes a├▒adir un chorrito de vino blanco). Tapa y cocina solo hasta que se abran. Retira los mariscos (descarta los cerrados) y reserva el l├¡quido colado (puedes a├▒adirlo al caldo principal).\n\nEn la paellera, calienta aceite de oliva. Sella las gambas/langostinos 1 minuto por lado. Ret├¡ralos y res├®rvalos.\n\nEl Sofrito (Base del Sabor):\n\nEn esa misma paellera (con el aceite de las gambas), baja el fuego a medio. Agrega la cebolla y sofr├¡e por 8-10 minutos hasta que est├® blanda.\n\nA├▒ade el ajo y el calamar/sepia. Cocina por 5 minutos m├ís hasta que el calamar est├® tierno.\n\nAgrega el tomate rallado y sofr├¡e hasta que el agua se evapore y se forme una pasta oscura (unos 5-8 minutos).\n\n┬íPaso Cr├¡tico!: Retira la paellera del fuego. A├▒ade el piment├│n dulce (paprika) y revuelve r├ípidamente. (Esto evita que el piment├│n se queme y amargue).\n\nTostar los Fideos (El Secreto):\n\nVuelve a poner la paellera a fuego medio-alto. Agrega un chorro m├ís de aceite de oliva si es necesario.\n\nVierte los fideos secos en la paellera, sobre el sofrito.\n\nRevuelve constantemente durante 3-5 minutos. Los fideos deben "fre├¡rse" en el aceite y el sofrito, cambiando de color p├ílido a un tono dorado/tostado. ┬íNo dejes que se quemen!\n\nLa Cocci├│n:\n\nVierte el caldo caliente con azafr├ín sobre los fideos tostados. El caldo debe cubrir generosamente los fideos.\n\nSazona con sal y pimienta. Revuelve una sola vez para distribuir los fideos uniformemente en la paellera.\n\n┬íNo la revuelvas m├ís! (Al igual que la paella).\n\nCocina a fuego medio-alto durante unos 10-12 minutos, o lo que indique el paquete de fideos.\n\nEl Acabado (Puntaeta):\n\nCuando falten unos 3-4 minutos y la mayor├¡a del caldo se haya absorbido, coloca decorativamente las gambas, mejillones y almejas que ten├¡as reservados por encima.\n\nSube el fuego al m├íximo durante el ├║ltimo minuto para crear el socarrat (la parte tostada del fondo).\n\nVariaci├│n Opcional: Algunos cocineros meten la paellera en el horno (precalentado a 200┬░C) durante los ├║ltimos 5 minutos. Esto hace que los fideos se sequen y se pongan "de punta" (puntaeta).\n\nReposo y Servicio:\n\nRetira del fuego y deja reposar la Fideu├á durante 5 minutos antes de servir.\n\nLl├®vala a la mesa en la misma paellera y s├¡rvela con gajos de lim├│n y un bol generoso de allioli al lado.	1	28	92	2023-06-27	1	0
28	Tacos de Pescado al Estilo Caj├║n	https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg		Prepara los Aderezos (Mise en Place):\n\nLa Ensalada (Slaw): En un bol, mezcla el repollo, la zanahoria (si usas) y el cilantro. Ali├▒a con el jugo de lim├│n y la sal. Revuelve bien y refrigera. Esta acidez es clave.\n\nLa Crema de Palta: En una licuadora o procesadora, pon la palta, el yogur, el manojo de cilantro, el jugo de lim├│n, el ajo (si usas) y la sal. Lic├║a hasta que est├® muy suave. Agrega 1-2 cucharadas de agua si est├í muy espesa. Reserva.\n\nPrepara el Pescado:\n\nSeca los trozos de pescado muy bien con toalla de papel (esto es vital para que se dore y no se cueza).\n\nPon todo el sazonador Caj├║n casero en un plato hondo.\n\nPasa cada trozo de pescado por el sazonador, cubri├®ndolo generosamente por todos lados.\n\nCocina el Pescado (El "Ennegrecido"):\n\nCalienta el aceite en un sart├®n grande (idealmente de hierro fundido) a fuego medio-alto. El sart├®n debe estar bien caliente.\n\nColoca los trozos de pescado en el sart├®n. No los muevas.\n\nCocina durante 2-3 minutos por lado. Las especias se tostar├ín y se pondr├ín de un color marr├│n oscuro (casi negro, de ah├¡ el nombre "blackened"). El pescado debe quedar cocido pero jugoso por dentro.\n\nRetira el pescado y desmen├║zalo ligeramente con un tenedor si los trozos son muy grandes.\n\nCalienta las Tortillas:\n\nEn el mismo sart├®n (ya sin el pescado) o en un comal, calienta las tortillas de ma├¡z 30 segundos por lado hasta que est├®n blandas y con algunas manchas tostadas. Gu├írdalas en un pa├▒o limpio para mantener el calor.\n\nArma los Tacos:\n\nToma una tortilla caliente.\n\nPon una cama de la ensalada (slaw).\n\nAgrega una porci├│n generosa del pescado Caj├║n.\n\nTermina con un chorrito abundante de la crema de palta y cilantro.\n\nSirve inmediatamente con gajos de lim├│n al lado.\n\n┬íSon picantes, ahumados, frescos, ├ícidos y cremosos, todo en un solo bocado!	1	28	93	2023-06-27	1	0
30	Tacos Horneados con Pollo a la Olla Lenta	https://www.themealdb.com/images/media/meals/ypxvwv1505333929.jpg		Fase 1: El Pollo en la Olla Lenta (Crock-Pot)\n\nColocar: Pon las pechugas de pollo en el fondo de la olla de cocci├│n lenta.\n\nSazonar: Espolvorea todo el sazonador de tacos sobre el pollo.\n\nCubrir: Vierte la salsa (y el caldo, si lo usas) sobre el pollo.\n\nCocinar: Tapa la olla y cocina a fuego BAJO (LOW) durante 4-6 horas o a fuego ALTO (HIGH) durante 3-4 horas. El pollo debe estar completamente cocido y tierno.\n\nDeshebrar: Saca las pechugas de pollo y ponlas en un bol grande. Usa dos tenedores para deshebrarlas (deber├¡a ser muy f├ícil).\n\nRemezclar: Vuelve a poner el pollo deshebrado en la olla con la salsa que qued├│ y revuelve bien. Deja que absorba el jugo por unos 10 minutos.\n\nFase 2: El Armado y Horneado de los Tacos\n\nPrecalentar: Precalienta el horno a 190┬░C (375┬░F).\n\nPreparar los Tacos: Coloca los "taco shells" de pie en una fuente para horno grande (tipo Pyrex de 9x13 pulgadas).\n\nPro-Tip: Si usas tacos comunes, puedes apoyarlos uno contra el otro para que no se caigan.\n\nLa Base (El Secreto): Con una cuchara, unta una capa delgada de porotos refritos en el fondo de cada taco shell. Esto act├║a como un "pegamento" y evita que el jugo del pollo ablande la base del taco.\n\nRellenar: Con una cuchara ranurada (para escurrir el exceso de l├¡quido), toma una porci├│n generosa del pollo deshebrado y rellena cada taco.\n\nCubrir con Queso: Cubre generosamente la parte superior de todos los tacos con el queso rallado (┬íno seas t├¡mido!).\n\nHornear: Hornea durante 12 a 15 minutos. El objetivo es que los tacos se calienten por completo, la base quede crujiente y el queso se derrita y burbujee.\n\nServir: Saca la fuente del horno con cuidado. Lleva la fuente directamente a la mesa y deja que cada persona agregue sus toppings fr├¡os (lechuga, crema agria, palta, etc.) por encima.\n\n┬íSon deliciosos, crujientes y una comida muy entretenida!	1	21	93	2023-06-27	1	0
32	Pimentones Rellenos con Quinoa y Porotos Negros	https://www.themealdb.com/images/media/meals/b66myb1683207208.jpg		Cocinar la Quinoa: En una olla, pon la taza de quinoa cruda y las 2 tazas de caldo de verduras. Lleva a ebullici├│n, baja el fuego, tapa y cocina por 15-20 minutos, o hasta que el l├¡quido se absorba y la quinoa est├® cocida. Reserva.\n\nPreparar los Pimentones (Pre-cocci├│n):\n\nPrecalienta el horno a 200┬░C (400┬░F).\n\nCorta los pimentones por la mitad a lo largo (desde el tallo hasta la base). Retira las semillas y las venas blancas.\n\nColoca las mitades de piment├│n (con el corte hacia arriba) en una bandeja de horno. Roc├¡alos con 1 cucharada de aceite de oliva, sal y pimienta.\n\nPre-hornea los pimentones vac├¡os durante 15 minutos. Esto asegura que queden tiernos y no crudos.\n\nHacer el Relleno (Mientras se hornean los pimentones):\n\nEn un sart├®n grande a fuego medio, calienta 1 cucharada de aceite. A├▒ade la cebolla y sofr├¡e por 5-7 minutos, hasta que est├® blanda.\n\nAgrega el ajo y todos los sazonadores (comino, piment├│n ahumado, aj├¡ en polvo, sal, pimienta). Revuelve por 1 minuto hasta que suelten su aroma.\n\nA├▒ade los porotos negros, el choclo y la salsa de tomate. Revuelve bien y cocina por 3-4 minutos hasta que est├® todo caliente.\n\nRetira del fuego.\n\nCombinar el Relleno:\n\nEn un bol grande, mezcla la quinoa cocida con la mezcla de porotos y verduras del sart├®n.\n\nAgrega el cilantro picado y el jugo de lim├│n sutil. Revuelve bien y prueba. Ajusta la sal si es necesario.\n\nArmar y Hornear:\n\nSaca la bandeja con los pimentones pre-horneados del horno. (Baja la temperatura del horno a 190┬░C (375┬░F)).\n\nRellena generosamente cada mitad de piment├│n con la mezcla de quinoa.\n\n(Opcional): Cubre cada piment├│n relleno con una buena cantidad de queso rallado.\n\nVierte ┬╝ taza de agua en el fondo de la bandeja (esto crea vapor y ayuda a la cocci├│n).\n\nHorneado Final:\n\nCubre la bandeja con papel de aluminio.\n\nHornea por 20 minutos.\n\nRetira el papel de aluminio y hornea por 10-15 minutos m├ís, o hasta que el queso est├® derretido y burbujeante, y los bordes del piment├│n est├®n tiernos.\n\nSirve caliente, decorado con palta en rodajas, un toque de crema agria o m├ís cilantro.	1	32	93	2023-06-27	1	0
\.


--
-- Data for Name: receta_del_dia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.receta_del_dia (fecha, id_receta) FROM stdin;
2025-11-01	18
2025-11-02	30
2025-11-03	26
2025-11-04	22
2025-11-05	20
\.


--
-- Data for Name: sesion_pago; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sesion_pago (id_sesion, session_id, provider, status, id_donacion, metadata, fecha_creacion, fecha_actualizacion) FROM stdin;
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuario (id_usr, nombre, apellido, email, password, estado, fecha_creacion, comentario, id_perfil) FROM stdin;
3	Claudio	Sanchez	cla.sanchezt@duo	$2a$06$WKZzXwq8yrrjIGRdfYYzQucfwFH53ssYZ9oKlzuYDZw0GmUVcsbpK	1	2024-05-26 17:15:11	\N	2
1	Admin	System	admin@recetas.com	$2a$06$WKZzXwq8yrrjIGRdfYYzQucfwFH53ssYZ9oKlzuYDZw0GmUVcsbpK	1	2023-06-26 23:58:57	\N	3
2	Usuario	Test	user@recetas.com	$2a$06$WKZzXwq8yrrjIGRdfYYzQucfwFH53ssYZ9oKlzuYDZw0GmUVcsbpK	1	2023-06-27 10:00:19	\N	1
47	PruebaThunder	Usuario	prueba.thunder+1@example.com	$2a$10$otBcZQ1QmlBSqcXbsBafzukdUDsg.XSVCbg6kYQYa00fyzAFHsZ0W	1	2025-11-02 02:18:24.65951	\N	1
48	Test3	User3	test.user.with.pass2@example.com	$2a$10$EPGlt99wQGqP09fusLuHNOyzHdIitUSGjKaTjFC5t/hVCJ3AD6kXK	1	2025-11-02 02:18:38.421064	\N	1
49	TestOK	UserOK	test.register.success@example.com	$2a$10$pV3BWD6rCAFINsvFU.UEZ.yBPGyAVopz.C/QblhEQebwddJqtd9e.	1	2025-11-02 02:18:50.533084	\N	1
50	Test	Usuario	test+20251101235000@example.com	$2a$10$L0BD2UtGWIE7f46fxmzunOGE6dip5w5HAT.fVEp0tJtLCPE2fwGNu	1	2025-11-02 02:50:01.575253	registro prueba	1
51	Test	Usuario	test+20251101235012@example.com	$2a$10$GJf2PtkQYwB3rE44dWDXSuoPJanmX/HgjXtS.XlgCDzDyhSgSAelG	1	2025-11-02 02:50:12.211913	registro prueba	1
52	TestFix	Usuario	testfix+20251101235330@example.com	$2a$10$WUELn1dGkJ4mBq4Z9U9xWuBAM2jax520FfLA5tQWaqzgBCPNqqKWe	1	2025-11-02 02:53:30.812559	prueba backend arreglado	1
53	AutoLogin	User	autologin+20251101235533@example.com	$2a$10$OgbJlbq116lNb1RG6y8R8OvsLGwzwNR2wEAILv08nrSUNGzOmudFG	1	2025-11-02 02:55:34.072244	prueba autologin	1
54	AutoLogin	User	autologin+20251101235609@example.com	$2a$10$ZYgfqjkacuU9TM9Zqg6MUuktUR22LBC0aBVFVulelLc7iFuGcYGy6	1	2025-11-02 02:56:09.978438	prueba autologin	1
55	ariel	palma	apalma@duo.cl	$2a$10$X98LoKMPJ9vJv1CzI9zapu9xUkse0P8.femNpmsgZBMGvyGJw7rre	1	2025-11-02 02:57:53.147369		1
56	QA	Auto	qa+1762054086830@example.com	$2a$10$gLv6A2JCZ0TsqCEcx4Dxne0NgcseXIfUIDbbms8nMfIH4wN0owVou	1	2025-11-02 03:28:07.402016	Registro autom├ítico QA	1
57	QA	Auto	qa+1762054210747@example.com	$2a$10$UkoKiTrOIhKpboJ7KIFxCO8W.GJeOzNjeE7z.zpeySpDcG2TKgEp6	1	2025-11-02 03:30:10.982025	Registro autom├ítico QA	1
58	QA	Auto	qa+1762054255720@example.com	$2a$10$TfK.3PV8e.SEau6TAcqYqe5hbAb535vHaX0aPZsI5UnHbJuS0swIi	1	2025-11-02 03:30:55.936621	Registro autom├ítico QA	1
59	QA	Auto	qa+1762054324293@example.com	$2a$10$ixc8XGnC.UYW4z/QUQ3Ss.Rig5MrfSPlQdNInhkNJhpJX73LUT6P2	1	2025-11-02 03:32:04.513302	Registro autom├ítico QA	1
60	QA	Auto	qa+1762054351402@example.com	$2a$10$b2/Fh/CJlEbsVGhfCDaACecjKIGQAetQhzwxyafstJmy0d7t2tDPm	1	2025-11-02 03:32:31.642135	Registro autom├ítico QA	1
61	QA	Auto	qa+1762054395265@example.com	$2a$10$66LaEmId05TyHYhl7UOM2.5prTa7E8QG37ZFjo1WON/.CTeVtlH0q	1	2025-11-02 03:33:15.554575	Registro autom├ítico QA	1
62	QA	Auto	qa+1762054415607@example.com	$2a$10$DBMpP7Z3s84Tb8kytHtVAuqS/qq1S6jCm9h2dZfqRVB8UKjgC8saG	1	2025-11-02 03:33:35.818041	Registro autom├ítico QA	1
63	QA	Auto	qa+1762054448648@example.com	$2a$10$wY2n8ucT7xH99uSzFW1X5OxyE.wm8HXy1NfQinKkp55gdQOjLMzWK	1	2025-11-02 03:34:08.85669	Registro autom├ítico QA	1
64	QA	Auto	qa+1762054543214@example.com	$2a$10$rw.Aupoy6HTtYjCWq7e/euD/uogZoUu4kuN4NZHIS7oRTM3ihVAa.	1	2025-11-02 03:35:43.459743	Registro autom├ítico QA	1
65	QA	Auto	qa+1762080071507@example.com	$2a$10$PtWeSSxE9GaH7duA2MmU/uLIknQCxTTSPBLlj4ZIPud/wuJ9EADTS	1	2025-11-02 10:41:12.231171	Registro autom├ítico QA	1
66	QA	Auto	qa+1762080166164@example.com	$2a$10$GKwdoed65tRwpyg6fZsU2.jTTcXpCL0talVXq9BLo9RqAGlbwWKgO	1	2025-11-02 10:42:46.407102	Registro autom├ítico QA	1
67	QA	Auto	qa+1762080992634@example.com	$2a$10$mJjHB82Wua5xr9zlzzifNusCEGXAHIluT8Jh9EwTt2zgc6NReZUhq	1	2025-11-02 10:56:33.17585	Registro autom├ítico QA	1
68	Test	User	test@example.com	$2a$10$at4BB.t0kktrb7106jhEEeaS5psrE1pTKKLOvdiTT1SpvOnLFQoki	1	2025-11-02 11:27:45.611338	\N	1
69	TestMG	UserMG	test.megusta.20251102_194213@example.com	$2a$10$u4bKMCaVLeIVTSF2IaHmPeXWCzweOcQGohUsoIeQySxAa7XbW6GNy	1	2025-11-02 22:42:14.446434	\N	1
70	TestMG	UserMG	test.megusta.20251102_195321@example.com	$2a$10$7CGNsAlYls48bWOVZ4/pXOSw6njR1sO.ExciRVnRrcoREFtoZxfmW	1	2025-11-02 22:53:21.664994	\N	1
71	TestMG	UserMG	test.megusta.20251102_200212@example.com	$2a$10$etazw0RbrFp1fBaTzq7YSe3qQh07r7.RiDsFREb6aAC6wEx9pfzQG	1	2025-11-02 23:02:12.29238	\N	1
72	TestMG	UserMG	test.megusta.20251102_210313@example.com	$2a$10$FvVhzH/jdPsMRttaKGcVEeJVapbDiEE/VfHCenMz3BHbgANVfyRN.	1	2025-11-03 00:03:13.483015	\N	1
73	TestMG	UserMG	test.megusta.20251102_210320@example.com	$2a$10$6rp.CkAFD0ej8OtMiVGEq.Ueo33NYM5id58ER2CtxJjiFp.rGLO9u	1	2025-11-03 00:03:20.472773	\N	1
74	TestMG	UserMG	test.megusta.20251102_210606@example.com	$2a$10$9wsI5i/XnUluNeKb8SAjAO.pI7iMSOr3us0/w3pXjlonvIZVU/WGq	1	2025-11-03 00:06:06.889529	\N	1
75	TestMG	UserMG	test.megusta.20251102_210802@example.com	$2a$10$hTjRU5UNUjen66Wd8Y0gzuiEerNSVxdGp49yTPVZqWEqmJY0oDTAq	1	2025-11-03 00:08:02.569631	\N	1
76	TestMG	UserMG	test.megusta.20251102_212106@example.com	$2a$10$mMIZK8JvkTJj1k..WVK.Qe9I2oOybZXkQp5iW9xmdSCK3z8DKdy9W	1	2025-11-03 00:21:06.375746	\N	1
77	TestFav	UserFav	test.favoritos.20251102_212734@example.com	$2a$10$otcPZPCJBzL9UnHTEB4teOIAozQgBBXOGUjDYp7CrXrjvane6FxBW	1	2025-11-03 00:27:35.080798	\N	1
78	TestFav	UserFav	test.favoritos.20251102_212813@example.com	$2a$10$DpAf8D6ghqfttieU6H.Qv.JHN0phpRW5o2BYwIaTOIMqiDsfBYpgm	1	2025-11-03 00:28:13.928581	\N	1
79	TestFav	UserFav	test.favoritos.20251102_212829@example.com	$2a$10$Pkhi6mn2Md0bQR7I0u95hOQTVDDjtSq8ZHhTSE3YCbaRGJ2J4BoWK	1	2025-11-03 00:28:29.696775	\N	1
80	TestFav	UserFav	test.favoritos.20251103_002414@example.com	$2a$10$.DL8gQF/rT5kDzRtvJ/uYOqh/MePjvrJg8tF7JAe41ysHF2D8OK4a	1	2025-11-03 03:24:15.164842	\N	1
81	TestMG	UserMG	test.megusta.20251103_002425@example.com	$2a$10$Q56iRKxT4mfpwuhJGRt3Iumh0nctGIU0sjggBgF9eWoUJpScjNwvK	1	2025-11-03 03:24:25.521016	\N	1
82	TestMG	UserMG	test.megusta.20251103_005721@example.com	$2a$10$5J0j9BsuCR6jE9y43SIvsuejdlU1Aooe0stgqZCTz8M/LbpIF2cU6	1	2025-11-03 03:57:22.394344	\N	1
83	TestFav	UserFav	test.favoritos.20251103_143356@example.com	$2a$10$B/VLxqLTt1RD5UduZiMz0OubkqRV7U6G6NsT4462kAFoAXCa7WipO	1	2025-11-03 17:33:53.009374	\N	1
84	TestFav	UserFav	test.favoritos.20251103_144020@example.com	$2a$10$HUoSbEV/pbufp/r87PS0o.0sFGqELe4MMzW0g7m3i/rG2nqDzzwgy	1	2025-11-03 17:40:20.39375	\N	1
\.


--
-- Name: categoria_id_cat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categoria_id_cat_seq', 63, true);


--
-- Name: comentario_id_comentario_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.comentario_id_comentario_seq', 1496, true);


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donacion_id_donacion_seq', 1, false);


--
-- Name: estrella_id_estrella_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.estrella_id_estrella_seq', 15, true);


--
-- Name: favorito_id_fav_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorito_id_fav_seq', 24, true);


--
-- Name: ingrediente_new_id_ingrediente_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ingrediente_new_id_ingrediente_seq', 48, true);


--
-- Name: me_gusta_id_megusta_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.me_gusta_id_megusta_seq', 21, true);


--
-- Name: pais_id_pais_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pais_id_pais_seq', 94, true);


--
-- Name: perfil_id_perfil_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.perfil_id_perfil_seq', 3, true);


--
-- Name: receta_id_receta_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.receta_id_receta_seq', 33, true);


--
-- Name: sesion_pago_id_sesion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sesion_pago_id_sesion_seq', 1, false);


--
-- Name: usuario_id_usr_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_usr_seq', 84, true);


--
-- Name: categoria categoria_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_key UNIQUE (nombre);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_cat);


--
-- Name: comentario comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id_comentario);


--
-- Name: donacion donacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_pkey PRIMARY KEY (id_donacion);


--
-- Name: estrella estrella_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estrella
    ADD CONSTRAINT estrella_pkey PRIMARY KEY (id_estrella);


--
-- Name: favorito favorito_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorito
    ADD CONSTRAINT favorito_pkey PRIMARY KEY (id_fav);


--
-- Name: ingrediente ingrediente_new_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingrediente
    ADD CONSTRAINT ingrediente_new_pkey PRIMARY KEY (id_ingrediente);


--
-- Name: me_gusta me_gusta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.me_gusta
    ADD CONSTRAINT me_gusta_pkey PRIMARY KEY (id_megusta);


--
-- Name: pais pais_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_nombre_key UNIQUE (nombre);


--
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id_pais);


--
-- Name: perfil perfil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id_perfil);


--
-- Name: receta_del_dia receta_del_dia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta_del_dia
    ADD CONSTRAINT receta_del_dia_pkey PRIMARY KEY (fecha);


--
-- Name: receta receta_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_nombre_key UNIQUE (nombre);


--
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (id_receta);


--
-- Name: sesion_pago sesion_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sesion_pago
    ADD CONSTRAINT sesion_pago_pkey PRIMARY KEY (id_sesion);


--
-- Name: favorito uk887bu4uo8aawt4vqxaf9tgpxu; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorito
    ADD CONSTRAINT uk887bu4uo8aawt4vqxaf9tgpxu UNIQUE (id_usr, id_receta);


--
-- Name: perfil uk_3b0dloqo94v7r6tjahpid9hc3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT uk_3b0dloqo94v7r6tjahpid9hc3 UNIQUE (nombre);


--
-- Name: me_gusta uq_megusta_receta_usuario; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.me_gusta
    ADD CONSTRAINT uq_megusta_receta_usuario UNIQUE (id_receta, id_usr);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usr);


--
-- Name: idx_comentario_id_receta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comentario_id_receta ON public.comentario USING btree (id_receta);


--
-- Name: idx_ingrediente_id_receta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ingrediente_id_receta ON public.ingrediente USING btree (id_receta);


--
-- Name: idx_receta_id_cat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receta_id_cat ON public.receta USING btree (id_cat);


--
-- Name: idx_receta_id_pais; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receta_id_pais ON public.receta USING btree (id_pais);


--
-- Name: idx_receta_id_usr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receta_id_usr ON public.receta USING btree (id_usr);


--
-- Name: ingrediente_nombre_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ingrediente_nombre_key ON public.ingrediente USING btree (lower(TRIM(BOTH FROM nombre)));


--
-- Name: ux_favorito_usr_receta; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_favorito_usr_receta ON public.favorito USING btree (id_usr, id_receta);


--
-- Name: ux_sesion_pago_sessionid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_sesion_pago_sessionid ON public.sesion_pago USING btree (session_id);


--
-- Name: ux_usuario_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_usuario_email ON public.usuario USING btree (email);


--
-- Name: sesion_pago set_fecha_actualizacion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_fecha_actualizacion BEFORE UPDATE ON public.sesion_pago FOR EACH ROW EXECUTE FUNCTION public.trg_update_fecha_actualizacion();


--
-- Name: categoria categoria_id_usr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_id_usr_fkey FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: comentario comentario_receta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_receta_fkey FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta) ON DELETE CASCADE;


--
-- Name: comentario comentario_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_usuario_fkey FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: donacion donacion_id_receta_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_id_receta_fk FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta) ON DELETE SET NULL;


--
-- Name: donacion donacion_id_usr_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_id_usr_fk FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr) ON DELETE SET NULL;


--
-- Name: ingrediente fk_ingrediente_receta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingrediente
    ADD CONSTRAINT fk_ingrediente_receta FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta) ON DELETE CASCADE;


--
-- Name: sesion_pago fk_sesion_pago_donacion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sesion_pago
    ADD CONSTRAINT fk_sesion_pago_donacion FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON DELETE SET NULL;


--
-- Name: me_gusta fkeu6k9bc9cdoikmwh3xc81oy48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.me_gusta
    ADD CONSTRAINT fkeu6k9bc9cdoikmwh3xc81oy48 FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta);


--
-- Name: estrella fkfey8w00kt60dhi2c4i96dj4b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estrella
    ADD CONSTRAINT fkfey8w00kt60dhi2c4i96dj4b2 FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: favorito fkh7xyncd05syjb4qbrc87i0da2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorito
    ADD CONSTRAINT fkh7xyncd05syjb4qbrc87i0da2 FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta);


--
-- Name: me_gusta fklt9disbee9m0fbsu33vxh7qdy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.me_gusta
    ADD CONSTRAINT fklt9disbee9m0fbsu33vxh7qdy FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: favorito fkrq0y1oifowf2v3iu8mtqqidvs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorito
    ADD CONSTRAINT fkrq0y1oifowf2v3iu8mtqqidvs FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: estrella fkrxcbprpobmiqkdxmoo32ylkld; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estrella
    ADD CONSTRAINT fkrxcbprpobmiqkdxmoo32ylkld FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta);


--
-- Name: pais pais_id_usr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_id_usr_fkey FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: receta receta_id_cat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_id_cat_fkey FOREIGN KEY (id_cat) REFERENCES public.categoria(id_cat);


--
-- Name: receta receta_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.pais(id_pais);


--
-- Name: receta receta_id_usr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_id_usr_fkey FOREIGN KEY (id_usr) REFERENCES public.usuario(id_usr);


--
-- Name: usuario usuario_id_perfil_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_id_perfil_fk FOREIGN KEY (id_perfil) REFERENCES public.perfil(id_perfil);


--
-- PostgreSQL database dump complete
--

\unrestrict XghASFgRMcEdaNuqEDlzZXmwfbYaG8ra1diyv3BZcmf9T4sUOrVx8k5PogAyvUy

