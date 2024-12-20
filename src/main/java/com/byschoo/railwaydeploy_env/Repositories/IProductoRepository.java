package com.byschoo.railwaydeploy_env.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import com.byschoo.railwaydeploy_env.Entities.Producto;

public interface IProductoRepository extends JpaRepository<Producto, Long>{

}
