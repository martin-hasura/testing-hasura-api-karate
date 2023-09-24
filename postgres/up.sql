CREATE SCHEMA cms;
CREATE TABLE cms."user" (
    id integer NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    role text DEFAULT 'author'::text NOT NULL
);
CREATE SEQUENCE cms.author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE cms.author_id_seq OWNED BY cms."user".id;
CREATE TABLE cms.post (
    id integer NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    author_id integer NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL
);
CREATE SEQUENCE cms.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE cms.posts_id_seq OWNED BY cms.post.id;
ALTER TABLE ONLY cms.post ALTER COLUMN id SET DEFAULT nextval('cms.posts_id_seq'::regclass);
ALTER TABLE ONLY cms."user" ALTER COLUMN id SET DEFAULT nextval('cms.author_id_seq'::regclass);
ALTER TABLE ONLY cms."user"
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);
ALTER TABLE ONLY cms.post
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY cms.post
    ADD CONSTRAINT post_author_id_fkey FOREIGN KEY (author_id) REFERENCES cms."user"(id);

INSERT INTO cms."user" (username, email, role) VALUES ('jane.doe', 'janedoe@test.com', 'author');
INSERT INTO cms."user" (username, email, role) VALUES ('john.doe', 'johndoe@test.com', 'author');
INSERT INTO cms."user" (username, email, role) VALUES ('jean.doe', 'jeandoe@test.com', 'editor');
INSERT INTO cms.post (title, content, created_at, author_id, status) VALUES ('This is a test post', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', '2021-03-29 20:45:19.268377+00', 1, 'published');
INSERT INTO cms.post (title, content, created_at, author_id, status) VALUES ('This is another test post', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', '2021-03-30 02:33:47.295446+00', 2, 'published');
INSERT INTO cms.post (title, content, created_at, author_id, status) VALUES ('This is a draft blog post', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', '2021-03-30 02:34:08.181484+00', 1, 'draft');