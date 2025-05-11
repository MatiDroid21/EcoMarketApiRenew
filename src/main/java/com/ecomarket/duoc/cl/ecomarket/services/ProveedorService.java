package com.ecomarket.duoc.cl.ecomarket.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecomarket.duoc.cl.ecomarket.model.Proveedor;
import com.ecomarket.duoc.cl.ecomarket.repository.ProveedorRepository;

import jakarta.transaction.Transactional;

@Service
@Transactional
public class ProveedorService {

    @Autowired
    private ProveedorRepository proveedorRepository;

    public List<Proveedor> listarTodos() {
        return proveedorRepository.findAll();
    }

    public Proveedor guardar(Proveedor proveedor) {
        return proveedorRepository.save(proveedor);
    }

    public Proveedor buscarPorId(Long id) {
        return proveedorRepository.findById(id).orElse(null);
    }

    public void eliminarPorId(Long id) {
        proveedorRepository.deleteById(id);
    }
}