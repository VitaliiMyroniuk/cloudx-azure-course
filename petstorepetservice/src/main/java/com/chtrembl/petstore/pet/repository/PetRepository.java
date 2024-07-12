package com.chtrembl.petstore.pet.repository;

import com.chtrembl.petstore.pet.model.Pet;
import static com.chtrembl.petstore.pet.model.Pet.StatusEnum;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {

	List<Pet> findAllByStatusIn(List<StatusEnum> statuses);
}
