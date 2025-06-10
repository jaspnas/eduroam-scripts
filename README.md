# Eduroam scripts

Scripts to make using eduroam on linux easier

## Running the script

You can run the script with: 
`./add_connection`

There are optional environment variables
```
DISABLE_POWERSAVE: Disables power saving on your wifi adapter
```

## Running tests

The tests use the [Bats](https://github.com/bats-core/bats-core) framework.
After installing `bats`, run the test suite with:

```bash
bats tests
```

### TODO:

- [ ] Add support for wpa_supplicant
- [ ] Add support for specifying certificate
- [ ] More env variable configuration
