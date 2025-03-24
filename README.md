# Get-LDAPQuery-ToCSV
Get-LDAPQuery-ToCSV.ps1 serves as a lightweight alternative to BloodHound and PowerView, enabling red teamers to customize LDAP queries with obfuscation and encoding techniques to evade detection. After successfully retrieving data, the results are exported to files in CSV format.

## Usage
```
Example:
. .\Get-LDAPQuery-ToCSV.ps1
Get-LDAPQuery-ToCSV -query "(&(objectClass=compu\54er)(!objectclass=UATtest1))" -exportpath "C:\\temp\\computer.csv"
```
## Useful LDAP Query
```
certauthorities - (objectClass=certificationAuthority)
certenrollservices - (objectClass=pKIEnrollmentService)
certtemplates - (objectClass=pKICertificateTemplate)
containers - (objectClass=container)
computers - (objectClass=computer)
domains - (objectClass=domain)
forests - (objectClass=crossRefContainer)
gpos - (objectClass=groupPolicyContainer)
groups - (objectClass=group)
ous - (objectClass=organizationalUnit)
trusted_domains - (objectClass=trustedDomain)
users - (&(objectClass=user)(|(objectCategory=person)(objectCategory=msDS-GroupManagedServiceAccount)(objectCategory=msDS-ManagedServiceAccount)))
```

## Enocode
```
Uppercase Letters (A-Z):
A: (\41)
B: (\42)
C: (\43)
D: (\44)
E: (\45)
F: (\46)
G: (\47)
H: (\48)
I: (\49)
J: (\4A)
K: (\4B)
L: (\4C)
M: (\4D)
N: (\4E)
O: (\4F)
P: (\50)
Q: (\51)
R: (\52)
S: (\53)
T: (\54)
U: (\55)
V: (\56)
W: (\57)
X: (\58)
Y: (\59)
Z: (\5A)
Lowercase Letters (a-z):
a: (\61)
b: (\62)
c: (\63)
d: (\64)
e: (\65)
f: (\66)
g: (\67)
h: (\68)
i: (\69)
j: (\6A)
k: (\6B)
l: (\6C)
m: (\6D)
n: (\6E)
o: (\6F)
p: (\70)
q: (\71)
r: (\72)
s: (\73)
t: (\74)
u: (\75)
v: (\76)
w: (\77)
x: (\78)
y: (\79)
z: (\7A)
Digits (1-9):
1: (\31)
2: (\32)
3: (\33)
4: (\34)
5: (\35)
6: (\36)
7: (\37)
8: (\38)
9: (\39)
```

## Search Time Threshold
- Search Time Threshold (default 30s): A LDAP query is considered expensive/inefficient if it takes more than 30 seconds.
- Expensive Search Results Threshold (default 10000): A LDAP query is considered expensive if it visits more than 10,000 entries.
- Inefficient Search Results Threshold (default 1000): A LDAP query is considered inefficient if the search visits more than 1,000 entries and the returned entries are less than 10 percent of the entries that it visited.
```
| Registry Path                                                                                             | Data Type | Default Value |
|-----------------------------------------------------------------------------------------------------------|-----------|---------------|
| HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters\Search Time Threshold (msecs)        | DWORD     | 30,000        |
| HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters\Expensive Search Results Threshold   | DWORD     | 10,000        |
| HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters\Inefficient Search Results Threshold | DWORD     | 1,000         |
```

## BloodHound Detection-Ideas-Rules
```
ldap_query:
   - EDR (Microsoft-Windows-LDAP-Client ETW)
rules: >
   - Channel:EDR AND EventType:LDAPQuery AND QueryFilter:("*\(objectclass\=computer\)\(userAccountControl\:1\.2\.840\.113556\.1\.4\.803\:\=8192\)\)*"
      OR "*\(sAMAccountType\=805306369\)\(\!\(UserAccountControl\:1\.2\.840\.113556\.1\.4\.803\:\=2\)\)*" OR "*\(objectcategory\=organizationalUnit\)\(objectclass\=domain\)\)\(gplink\=\*\)\(flags\=\*\)*"
      OR "*\(objectcategory\=groupPolicyContainer\)\(flags\=\*\)*" OR "*\(samaccounttype\=805306368\)\(serviceprincipalname\=\*\)*"
```

## Reference
- [Invoke-Maldaptive](https://github.com/MaLDAPtive/Invoke-Maldaptive) by MaLDAPtive
- [Detection-Ideas-Rules](https://github.com/vadim-hunter/Detection-Ideas-Rules/blob/main/Tools/BloodHound.yaml) by vadim-hunter
- [ldapad-logging](https://cravaterouge.com/articles/ldapad-logging/) by cravaterouge.com
