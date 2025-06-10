# Eduroam scripts

Scripts to make using eduroam on linux easier

## Running the script

You can run the script with:
`./add_connection [--no-up]`

There are optional environment variables
```
DISABLE_POWERSAVE: Disables power saving on your wifi adapter
```

Script arguments
```
--no-up: Skip activating the connection after it is created
```

### TODO:

- [ ] Add support for wpa_supplicant
- [ ] Add support for specifying certificate
- [ ] More env variable configuration
