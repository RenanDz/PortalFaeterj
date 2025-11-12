package br.com.portalfaeterj.model;

import java.util.Date;

public class Comentario {
    private int id;
    private int noticiaId;
    private int usuarioId;
    private String usuarioNome;
    private String texto;
    private Date criadoEm;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getNoticiaId() { return noticiaId; }
    public void setNoticiaId(int noticiaId) { this.noticiaId = noticiaId; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getUsuarioNome() { return usuarioNome; }
    public void setUsuarioNome(String usuarioNome) { this.usuarioNome = usuarioNome; }

    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }

    public Date getCriadoEm() { return criadoEm; }
    public void setCriadoEm(Date criadoEm) { this.criadoEm = criadoEm; }
}
