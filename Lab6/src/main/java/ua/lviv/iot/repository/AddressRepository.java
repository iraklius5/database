package ua.lviv.iot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ua.lviv.iot.domain.Address;

@Repository
public interface AddressRepository extends JpaRepository<Address, Integer> {
}
