logger.info("Starting address list initialization. orchApiIndResBean is null? {}", (orchApiIndResBean == null));

// 1. Safe Initialization (Matching original boolean logic EXACTLY)
if (orchApiIndResBean != null) {
    logger.info("Adding ProofOfAddr to addressList.");
    addressList.add(orchApiIndResBean.getProofOfAddr());

    String proofIsCorres = orchApiIndResBean.getProofOfAddr().getIsCorres();
    logger.info("Evaluating ProofOfAddr IsCorres flag: '{}'", proofIsCorres);
    
    if (!"CO".equalsIgnoreCase(proofIsCorres)) {
        logger.info("ProofOfAddr is NOT 'CO'. Adding CorresAddr to addressList.");
        addressList.add(orchApiIndResBean.getCorresAddr());
    }

    // Retained the original 'OR' (||) logic
    boolean isProofNotJ = !"J".equalsIgnoreCase(orchApiIndResBean.getProofOfAddr().getIsJuris());
    boolean isCorresNotJ = orchApiIndResBean.getCorresAddr() == null || !"J".equalsIgnoreCase(orchApiIndResBean.getCorresAddr().getIsJuris());
    
    logger.info("Jurisdiction evaluation - isProofNotJ: {}, isCorresNotJ: {}", isProofNotJ, isCorresNotJ);

    if (isProofNotJ || isCorresNotJ) {
        logger.info("Condition met for Jurisdiction address. Adding JurAddr to addressList.");
        addressList.add(orchApiIndResBean.getJurAddr());
    }
} else {
    logger.info("[ERROR/WARN] orchApiIndResBean is null. Skipping initialization block.");
}

logger.info("Beginning address processing loop. Total addresses to process: {}", addressList.size());

// 2. Main Processing Loop
for (int i = 0; i < addressList.size(); i++) {
    Object currentItem = addressList.get(i);
    logger.info("--- Processing address index [{}] ---", i);
    
    if (currentItem == null) {
        logger.info("[WARN] Address item at index {} is null. Continuing to next iteration.", i);
        continue;
    }

    logger.info("Evaluating class type for index {}. CurrentItem class: {}", i, currentItem.getClass().getName());

    // Strict class equality, matching original logic
    if (proofOfAddr != null && currentItem.getClass().equals(proofOfAddr.getClass())) {
        logger.info("Match found: Item at index {} is of type ProofOfAddrBean", i);

        proofOfAddr = (ProofOfAddrBean) currentItem;
        AddressBean actualAddr = proofOfAddr.getAddress();

        if (actualAddr != null) {
            logger.info("actualAddr is present. Populating BASE address details to map.");
            populateAddressDetailsToMap(m, actualAddr, "", actualAddr.getCountryName(), customerDetailsService);

            logger.info("::::::::::::::::::::::::::::::: State - {}", actualAddr.getState());

            if ("CO".equalsIgnoreCase(proofOfAddr.getIsCorres())) {
                logger.info("PRIMARY ADDRESS == CO ADDRESS FOR CIF >>> {}", cif_num);
                corresAddr = actualAddr;
                logger.info("Setting sameAsPOA flag to 'R' for corresAddr.");
                corresAddr.setSameAsPOA("R");
                
                logger.info("Populating CORR_ map details.");
                populateAddressDetailsToMap(m, corresAddr, "corr_", corresAddr.getCountryName(), customerDetailsService);
            }

            if ("J".equalsIgnoreCase(proofOfAddr.getIsJuris())) {
                logger.info("PRIMARY ADDRESS == CO ADDRESS == J ADDRESS FOR CIF >>> {}", cif_num);
                jurAddr = actualAddr;
                
                logger.info("Populating JUR_ map details.");
                populateAddressDetailsToMap(m, jurAddr, "jur_", jurAddr.getCountryName(), customerDetailsService);
            }
        } else {
            logger.info("[WARN] actualAddr inside ProofOfAddrBean is null for index {}", i);
        }
    } 
    // Strict class equality, matching original logic
    else if (corresAddr != null && currentItem.getClass().equals(corresAddr.getClass())) {
        logger.info("Match found: Item at index {} is of type AddressBean (corresAddr class)", i);
        
        logger.info("PRIMARY ADDRESS != CO ADDRESS FOR CIF >>> {}", cif_num);
        AddressBean a = (AddressBean) currentItem;
        
        boolean isCorres = "CO".equalsIgnoreCase(a.getIsCorres());
        boolean isJuris = "J".equalsIgnoreCase(a.getIsJuris());
        
        logger.info("FOR ADDRESS {} IS (CORRESPONDANCE ADDR {}) (JURISDICTION ADDR {}) FOR CIF >>> {}", 
                    i, isCorres, isJuris, cif_num);

        if (isCorres) {
            logger.info("Address is exclusively Correspondence Address.");
            corresAddr = a;
            
            if (isJuris) {
                logger.info("CO ADDRESS == J ADDRESS FOR CIF >>> {}", cif_num);
                jurAddr = a;
                logger.info("Setting SameAsCorresAddr flag to 'CO' for jurAddr.");
                jurAddr.setSameAsCorresAddr("CO");
                
                logger.info("Populating JUR_ map details.");
                populateAddressDetailsToMap(m, jurAddr, "jur_", jurAddr.getCountryName(), customerDetailsService);
            }
            
            logger.info("Populating CORR_ map details.");
            populateAddressDetailsToMap(m, corresAddr, "corr_", corresAddr.getCountryName(), customerDetailsService);

        } else if (isJuris) {
            logger.info("PRIMARY ADDRESS != CO ADDRESS != J ADDRESS FOR CIF >>> {}", cif_num);
            jurAddr = a;
            
            boolean addrLinesMatch = (corresAddr != null && corresAddr.getAddrLine1() != null 
                && corresAddr.getAddrLine1().equalsIgnoreCase(jurAddr.getAddrLine1()));
                
            logger.info("Checking if JurAddrLine1 matches CorresAddrLine1. Result: {}", addrLinesMatch);
            
            if (addrLinesMatch) {
                logger.info("Address lines match. Setting SameAsCorresAddr flag to 'CO' for jurAddr.");
                jurAddr.setSameAsCorresAddr("CO");
            }
            
            // REVERTED: Using corresAddr.getCountryName() exactly as the original code did
            String legacyCountryName = (corresAddr != null) ? corresAddr.getCountryName() : jurAddr.getCountryName();
            logger.info("Using legacy country name resolution: '{}'", legacyCountryName);
            
            logger.info("Populating JUR_ map details.");
            populateAddressDetailsToMap(m, jurAddr, "jur_", legacyCountryName, customerDetailsService);
        } else {
            logger.info("[DEBUG] Address at index {} is neither CO nor J.", i);
        }
    } else {
        logger.info("[DEBUG] Item at index {} did not match proofOfAddr or corresAddr classes.", i);
    }
}
logger.info("Address processing loop completed successfully.");





private void populateAddressDetailsToMap(Map<String, Object> map, AddressBean addr, String prefix, String countryOverride, CustomerDetailsService service) {
    logger.info("--> ENTERING populateAddressDetailsToMap with prefix: '{}', countryOverride: '{}'", prefix, countryOverride);

    if (addr == null || service == null) {
        logger.info("<-- [ERROR/WARN] ABORTING populateAddressDetailsToMap: AddressBean or CustomerDetailsService is null!");
        return;
    }

    String pin = addr.getPin();
    String district = addr.getDistrict();
    String subDist = addr.getSubDistrict();
    String state = addr.getState();

    logger.info("Fetching service data for Pin: '{}', District: '{}', SubDist: '{}', State: '{}'", pin, district, subDist, state);

    try {
        map.put(prefix + "district_list", service.getDistrictListforPin(pin, district, countryOverride));
        map.put(prefix + "pin_list", service.getPinforNew(pin, countryOverride));
        map.put(prefix + "village_List", service.getVillagesBySubDist(state, district, subDist, countryOverride));
        map.put(prefix + "sub_district_List", service.getfetchSubDistrict(district, state, countryOverride));
        map.put(prefix + "state_list", service.getStateListforNew(countryOverride));
        logger.info("<-- SUCCESS: populated map with prefix '{}'", prefix);
    } catch (Exception e) {
        // Logging the exception entirely as an INFO log, per instructions
        logger.info("<-- [ERROR] Exception occurred while calling CustomerDetailsService for prefix '{}': {}", prefix, e.getMessage(), e);
    }
}
