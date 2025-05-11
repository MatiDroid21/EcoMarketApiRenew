package com.ecomarket.duoc.cl.ecomarket.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ecomarket.duoc.cl.ecomarket.model.Proveedor;

public interface ProveedorRepository extends JpaRepository<Proveedor, Long> {
    // Aquí puedes agregar métodos personalizados si es necesario
    // Por ejemplo, buscar por nombre o email
    // List<Proveedor> findByNombre(String nombre);
    // List<Proveedor> findByEmail(String email);

}
