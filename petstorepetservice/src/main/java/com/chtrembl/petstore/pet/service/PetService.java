package com.chtrembl.petstore.pet.service;

import com.chtrembl.petstore.pet.model.Pet;
import static com.chtrembl.petstore.pet.model.Pet.StatusEnum;
import com.chtrembl.petstore.pet.repository.PetRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PetService {

	private final PetRepository petRepository;

	public List<Pet> getPets(List<String> statuses) {
		List<StatusEnum> statusEnums = statuses
				.stream()
				.map(StatusEnum::fromValue)
				.toList();
		return petRepository.findAllByStatusIn(statusEnums);
	}
}
