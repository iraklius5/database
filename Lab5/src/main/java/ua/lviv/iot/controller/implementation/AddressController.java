package ua.lviv.iot.controller.implementation;

import ua.lviv.iot.controller.GeneralController;
import ua.lviv.iot.model.dal.dao.implementation.AddressDAO;
import ua.lviv.iot.model.entity.Address;

public class AddressController extends GeneralController<Address> {
    public AddressController(){
        super(new AddressDAO());
    }
}
