package com.ecomarket.duoc.cl.ecomarket.controller;

import java.util.List;

import org.apache.catalina.connector.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ecomarket.duoc.cl.ecomarket.model.Producto;
import com.ecomarket.duoc.cl.ecomarket.services.ProductoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;


@RestController
@RequestMapping("/api/v1/productos")
public class PoroductoController {
    @Autowired
    private ProductoService ps; 

    @GetMapping
    public ResponseEntity <List<Producto>> listarProductos(){
        List<Producto> productos = ps.listarTodos();
        if(productos.isEmpty()){
            return ResponseEntity.noContent().build();
        }else{
            return ResponseEntity.ok(productos);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> buscarPorId(@PathVariable Long id){
        Producto prod = ps.buscarporID(id);
        if(prod == null){
            return ResponseEntity.status(404).body("Producto no encontrado con id "+id);
        }else{
            return ResponseEntity.ok(prod);
        }
    }

    @PostMapping()
    public ResponseEntity<?> crearProducto(@RequestBody Producto producto){
        try{
            ps.guardarProd(producto);
            return ResponseEntity.status(201).body("Producto ingresado");
        }catch(Exception ex){
            return ResponseEntity.status(500).body("Producto no Ingresado, problema: "+ex.getMessage());
        }
    }

 @PutMapping("/{id}")
public ResponseEntity<?> modificarProducto(@PathVariable Long id, @RequestBody Producto producto) {
    try {
        Producto productoExistente = ps.buscarporID(id);
        if (productoExistente == null) {
            return ResponseEntity.status(404).body("Producto no encontrado");
        }

        productoExistente.setNombre(producto.getNombre());
        productoExistente.setDescripcion(producto.getDescripcion());
        productoExistente.setPrecio(producto.getPrecio());
        productoExistente.setCategoria_id(producto.getCategoria_id());
        productoExistente.setProveedor_id(producto.getProveedor_id());
        productoExistente.setEcoscore(producto.getEcoscore());
        productoExistente.setActivo(producto.getActivo());

        ps.guardarProd(productoExistente);
        return ResponseEntity.ok("Producto actualizado con éxito");
    } catch (Exception e) {
        return ResponseEntity.status(500).body("Error al actualizar producto");
    }
}

    
}
