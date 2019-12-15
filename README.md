# Validator

## Instalation
```bash
curl -o- https://raw.githubusercontent.com/krisboit/validator/master/install.sh | bash
```

## How to use
- Setup validator
```bash
~/validator/validator setup <blockchain> <network> <validator>
```

example:
```bash
~/validator/validator setup near stakewars moonlet1
```

- Start validator
```bash
~/validator/validator start
```

- Stop validator
```bash
~/validator/validator stop
```