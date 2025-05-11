package com.ecomarket.duoc.cl.ecomarket.repository;

import java.lang.foreign.Linker.Option;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ecomarket.duoc.cl.ecomarket.model.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario,Long>{
    Optional<Usuario> findByRut(String rut);
    void deleteByRut(String rut);
}
