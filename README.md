## Usage

```
 source bash-magic.sh 
```

 1. Type a command which produces a list of string (space or newline limited)
 2. Mark the command by postixing it with "#list"
 3. Type a command you want to loop on with $var variable
 4. Mark the commane bu postfixing it with "#loop"
 5. Run the function: `generateMagicFn`

## Example

once you have a `list` command, just append a comment `#list` to the end.
```
aws ec2 describe-regions \
  --query 'Regions[? starts_with(RegionName, `eu`) ].RegionName' \
  --out text #list
```

build up the `loop` command with `$var`:
```
var=eu-central-1

aws ec2 describe-instances \
  --query 'Reservations[].Instances[].{id: InstanceId, zone:Placement.AvailabilityZone , ip: PublicIpAddress}' \
  --region $var \
  --out table #loop

generateMagicFn
```

Now the function is generated and you can reuse as:
```
magicFn
```