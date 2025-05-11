package com.ecomarket.duoc.cl.ecomarket.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecomarket.duoc.cl.ecomarket.model.Producto;
import com.ecomarket.duoc.cl.ecomarket.repository.ProductoRepository;

import jakarta.transaction.Transactional;

@Service
@Transactional
public class ProductoService {
    @Autowired
    private ProductoRepository pr;

    public List<Producto> listarTodos(){
        return pr.findAll();
    }

    public Producto guardarProd(Producto producto){
        return pr.save(producto);
    }

    public Producto buscarporID(Long id){
        return pr.findById(id).orElse(null);
    }

    public void eliminarPorId(Long id){
        pr.deleteById(id);
    }
}
