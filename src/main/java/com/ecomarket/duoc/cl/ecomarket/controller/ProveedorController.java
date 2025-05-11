package com.ecomarket.duoc.cl.ecomarket.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.ecomarket.duoc.cl.ecomarket.model.Proveedor;
import com.ecomarket.duoc.cl.ecomarket.services.ProveedorService;

@RestController
@RequestMapping("/api/v1/proveedores")

public class ProveedorController {
    @Autowired
    private ProveedorService proveedorService;

    @GetMapping
    public ResponseEntity<List<Proveedor>> listarProveedores() {
        List<Proveedor> proveedores = proveedorService.listarTodos();
        if (proveedores.isEmpty()) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.ok(proveedores);
        }
    }
    //buscar x id
    @GetMapping("/{id}")
    public ResponseEntity<?> buscarPorId(@PathVariable Long id) {
        Proveedor proveedor = proveedorService.buscarPorId(id);
        if (proveedor == null) {
            return ResponseEntity.status(404).body("Proveedor no encontrado");
        } else {
            return ResponseEntity.ok(proveedor);
        }
    }

    @PostMapping
    public ResponseEntity<?> crearProveedor(@RequestBody Proveedor proveedor) {
        try {
            proveedorService.guardar(proveedor);
            return ResponseEntity.status(201).body("Proveedor creado con éxito");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error al crear proveedor");
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> actualizarProveedor(@PathVariable Long id, @RequestBody Proveedor proveedor) {
        try {
            Proveedor proveedorExistente = proveedorService.buscarPorId(id);
            if (proveedorExistente == null) {
                return ResponseEntity.status(404).body("Proveedor no encontrado");
            }

            proveedorExistente.setNombre(proveedor.getNombre());
            proveedorExistente.setEmail(proveedor.getContacto());
            proveedorExistente.setTelefono(proveedor.getTelefono());
            proveedorExistente.setEmail(proveedor.getEmail());
            proveedorExistente.setActivo(proveedor.getActivo());
            proveedorExistente.setFechaCreacion(proveedor.getFechaCreacion());

            proveedorService.guardar(proveedorExistente);
            return ResponseEntity.ok("Proveedor actualizado con éxito");

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error al actualizar proveedor");
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminarProveedor(@PathVariable Long id) {
        try {
            Proveedor proveedor = proveedorService.buscarPorId(id);
            if (proveedor == null) {
                return ResponseEntity.status(404).body("Proveedor no encontrado");
            }
            proveedorService.eliminarPorId(id);
            return ResponseEntity.ok("Proveedor eliminado con éxito");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error al eliminar proveedor");
        }
    }
}
