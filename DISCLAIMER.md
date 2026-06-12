# ⚠️ DISCLAIMER — READ BEFORE USE

> **THIS IS OPEN-SOURCE, DECENTRALIZED, EXCEPTIONALLY EXPERIMENTAL SOFTWARE.**
>
> **IT IS PROVIDED "AS-IS" AND "AS-AVAILABLE" WITH ABSOLUTELY NO WARRANTY
> AND NO LIABILITY OF ANY KIND.**
>
> **BY CLONING, BUILDING, RUNNING, DEPLOYING, MODIFYING, INTERACTING WITH,
> OR RELYING ON ANY PART OF THIS REPOSITORY — INCLUDING SCRIPTS,
> CONFIGURATION FILES, DOCKER IMAGES, SMART-CONTRACT ADDRESSES, RPC
> ENDPOINTS, OR DOCUMENTATION — YOU ACKNOWLEDGE AND ACCEPT ALL OF THE RISKS
> DESCRIBED BELOW AND ASSUME FULL AND SOLE RESPONSIBILITY FOR ANY LOSS,
> DAMAGE, OR HARM THAT RESULTS.**

---

## 0. This Is an Experiment. Treat It Like One.

This bridge is a **research-grade, community-operated experiment**. It is not
a product, not a service, and not a company. It has no support desk, no
service-level agreement, no insurance, no backstop, and no one whose job it
is to make you whole if something breaks.

- **It may stop working at any moment, permanently, with no notice.**
- **It may contain bugs that result in the total loss of everything it
  touches.**
- **Nobody is on call. Nobody owes you a fix. Nobody owes you a refund.**
- **You should assume that any value you put through it can disappear and
  never come back.**

If that is not acceptable to you, **do not use this software, do not run
this infrastructure, and do not interact with these contracts.** Only commit
funds, hardware, time, or reputation that you can afford to lose entirely.

---

## 1. No Warranty

**THE SOFTWARE AND ANY ASSOCIATED CONFIGURATION, DOCUMENTATION, AND SCRIPTS
ARE PROVIDED "AS IS" AND "AS AVAILABLE", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, NON-INFRINGEMENT,
ACCURACY, COMPLETENESS, RELIABILITY, AVAILABILITY, OR UPTIME.**

**NO REPRESENTATION OR WARRANTY IS MADE THAT THE SOFTWARE IS FREE FROM BUGS,
DEFECTS, VULNERABILITIES, OR MALICIOUS CODE, OR THAT IT WILL FUNCTION
CORRECTLY, CONTINUOUSLY, SECURELY, OR AT ALL UNDER ANY SPECIFIC SET OF
CIRCUMSTANCES.**

**NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED FROM THIS
REPOSITORY, ITS AUTHORS, OR ITS CONTRIBUTORS CREATES ANY WARRANTY NOT
EXPRESSLY STATED HERE — AND NONE IS EXPRESSLY STATED.**

## 2. No Liability — For Anyone Involved

**IN NO EVENT AND UNDER NO LEGAL THEORY (WHETHER IN CONTRACT, TORT,
NEGLIGENCE, STRICT LIABILITY, OR OTHERWISE) SHALL ANY OF THE FOLLOWING — THE
AUTHORS, CONTRIBUTORS, AND MAINTAINERS OF THIS REPOSITORY, *AS WELL AS ANY
INDEPENDENT VALIDATOR OPERATOR, RELAYER OPERATOR, LIQUIDITY PROVIDER, OR
OTHER PARTICIPANT WHO RUNS THIS SOFTWARE* — BE LIABLE FOR:**

- **ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, CONSEQUENTIAL,
  OR PUNITIVE DAMAGES;**
- **LOSS OF FUNDS, TOKENS, ASSETS, PROFITS, REVENUE, BUSINESS, DATA,
  GOODWILL, OR OPPORTUNITY;**
- **COSTS OF PROCUREMENT OF SUBSTITUTE SERVICES;**
- **ANY CLAIMS BROUGHT BY THIRD PARTIES, INCLUDING ANY END USER OF THE
  BRIDGE;**

**ARISING OUT OF OR IN CONNECTION WITH THE USE OF, INABILITY TO USE,
OPERATION OF, OR INTERACTION WITH THIS SOFTWARE, THE BRIDGE, THE RELATED
CONTRACTS, OR ANY SERVICE OR INFRASTRUCTURE BUILT ON TOP OF IT, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.**

This limitation is intended to protect **everyone who merely participates in
the network**, not only the original authors. See Section 3.

## 3. Protection for Validators and Relayers

**This section exists specifically to make clear that the people who keep
this experiment running are not on the hook for what users do.**

Validators and relayers are the volunteers who operate the neutral
infrastructure that makes a decentralized bridge possible. They are not the
bridge, they are not its operator, and they are not a counterparty to any
user. This section describes what they are — and, just as importantly, what
they are **not**.

### 3.1 Validators and relayers are neutral, automated infrastructure

- **A validator** observes a chain and produces cryptographic signatures
  (checkpoints) attesting to what it saw. **It does not move, hold, route,
  approve, or have any discretion over user funds.** It signs data. That is
  all it does.
- **A relayer** is an automated process that forwards already-signed messages
  from one chain to another and pays destination gas to submit them. **It is
  a postman for cryptographic messages.** It cannot create messages, cannot
  alter their contents, cannot choose who receives funds, and cannot reverse,
  freeze, or seize anything.
- Both run **unattended, deterministic software** following a fixed protocol.
  Neither exercises judgment over individual transactions, and neither has
  any ability to favor, block, reverse, or modify a user's transfer outside
  the mechanical rules of the protocol.

### 3.2 Validators and relayers do not take custody

- **At no point does a validator or relayer take custody, possession, or
  control of any user's funds, tokens, or assets.** Collateral is held by
  smart contracts on-chain, not by any operator. Operators cannot withdraw,
  redirect, or spend user assets.
- Funding a relayer's own gas wallet is the operator paying **their own
  operating cost** to submit transactions. It is not custody of, commingling
  with, or control over anyone else's property.

### 3.3 No agency, partnership, fiduciary, or counterparty relationship

- **Running a validator or relayer from this repository makes you an
  independent operator of your own infrastructure.** You are not an employee,
  agent, partner, joint venturer, or contractor of the authors, of GenesisL1,
  of any user, or of any other operator.
- **No operator owes any user a fiduciary duty, a duty of care, a duty to
  continue operating, a duty of uptime, or any duty of any kind.** Operators
  may start, stop, upgrade, reconfigure, or shut down their infrastructure at
  any time, for any reason or no reason, without notice and without
  liability.
- **No operator is a counterparty to any user's transaction.** Users transact
  with smart contracts and with the protocol, not with the people running
  nodes.

### 3.4 Operators are not responsible for users, user funds, or user conduct

- **Operators do not, and cannot, vet, monitor, screen, approve, or police
  who uses the bridge or what they use it for.** A permissionless protocol
  serves whoever sends it a valid message.
- **An operator is not responsible for, and accepts no liability arising
  from, the actions, transactions, losses, mistakes, or conduct of any user
  or third party** — including funds sent to the wrong address, funds lost to
  user error, funds lost to a contract bug, or any use of the bridge by
  anyone for any purpose.
- **By relying on a validator or relayer, a user acknowledges that the
  operator is providing neutral infrastructure as-is, with no warranty and no
  liability, and waives any claim against that operator** to the maximum
  extent permitted.

### 3.5 Operators run at their own risk

Being an operator carries its own risks. You accept them. They include, at
minimum: the loss of your own gas funds; slashing or reputational
consequences if your validator signs incorrectly or your keys are
compromised; the cost of hardware, bandwidth, and time; exposure of your
server's IP address or metadata to the public internet; and the possibility
that the software you are running contains defects that cause you loss. **You
operate voluntarily, for your own reasons, at your own expense, and at your
own risk.**

## 4. Decentralized Software — No Central Operator

This repository describes a **permissionless, decentralized protocol built on
public blockchains**. There is no central operator, provider, custodian,
intermediary, fiduciary, or service in the traditional sense.

- **There is no central entity that controls the bridge, holds user funds,
  or can reverse transactions.**
- **No party — not the authors, not any operator — can recover funds that
  are lost, misdirected, sent to the wrong chain, bridged to a wrong address,
  or stolen.**
- **Transactions on blockchains are final and irreversible by design.**
  Mistakes cannot be undone by anyone.

## 5. Risks You Explicitly Accept

The following is a **non-exhaustive** list of risks. There may be others not
described here. **You are responsible for your own due diligence.**

### 5.1 Smart-contract risk

- **The bridge contracts may contain bugs, logic errors, or vulnerabilities
  that result in loss or theft of all assets locked in them.**
- **The contracts have not been audited by a formal third-party security
  firm** unless explicitly stated otherwise in this repository.
- **Upgrades, proxy admin changes, or ISM reconfigurations may alter the
  behavior of the bridge in ways that affect existing users and locked
  collateral.**
- **Exploits on Hyperlane core contracts, their dependencies, or underlying
  chains may compromise the bridge.**

### 5.2 Validator and relayer reliability risk

> This is about the *reliability* of infrastructure as a risk to **users**.
> For the *protection* of the operators themselves, see Section 3.

- **Validators may have their keys compromised, sign incorrect checkpoints,
  collude, or go offline.** The ISM threshold configuration mitigates but
  does not eliminate this risk.
- **The current ISM threshold on this route is low (1 validator per
  direction).** A single compromised validator could potentially forge
  messages. Users are relying on the integrity of that validator.
- **Relayers may be unreliable, fail to deliver, submit transactions with
  incorrect gas, or be the target of attacks.** Messages can be stuck or
  delayed.
- **The relayer wallet is funded by whoever operates the relayer.** If it
  runs out of gas, deliveries stop. There is no guarantee of uptime, and no
  operator is obligated to keep running.

### 5.3 Bridge design risk

- **The wL1 token is a wrapped representation. 1 wL1 on Base is only worth
  1 L1 so long as the collateral on GenesisL1 remains fully backed and the
  bridge functions correctly.** In a failure scenario, wL1 may trade at a
  significant discount or become worthless.
- **An IGP (Interchain Gas Paymaster) is not currently deployed on
  GenesisL1.** The relayer currently subsidizes destination gas. If the
  relayer stops operating, messages will not be delivered.
- **Cross-chain message ordering, finality assumptions, and reorgs on either
  chain may cause unexpected behavior.**

### 5.4 Blockchain and infrastructure risk

- **The underlying blockchains (GenesisL1, Base, Ethereum) may fork, halt,
  become congested, reorganize, or cease to exist.**
- **RPC endpoints may return stale, incorrect, or malicious data. They may be
  rate-limited, throttled, offline, or censor requests.**
- **GenesisL1's `eth_estimateGas` is known to return incorrect results.**
  Tools that do not account for this may fail, or worse, submit transactions
  with incorrect gas pricing. See
  [docs/troubleshooting.md](docs/troubleshooting.md).
- **Load-balanced RPC setups (e.g. HAProxy) can silently serve stale state
  from slow backends, which causes validators and relayers to operate on
  incorrect data.**

### 5.5 Key-management and operational risk

- **You are solely responsible for the private keys you generate, import, and
  use.** If you lose a key, you lose the associated funds. If a key is
  compromised, any assets it controls can be stolen.
- **Re-using keys across validator, relayer, and user wallets increases blast
  radius in the event of compromise.**
- **Running infrastructure on compromised, poorly configured, or unpatched
  systems exposes your keys and funds to theft.**
- **Exposing RPC endpoints, signature storage buckets, or other operational
  endpoints without appropriate authentication may allow third parties to
  abuse or attack your infrastructure.**

### 5.6 Market, economic, and adversarial risk

- **wL1 and L1 are volatile assets and may lose all of their market value.**
- **Liquidity, including that provided on Base DEXes, may be shallow,
  withdrawn, manipulated, or frontrun.**
- **MEV, sandwich attacks, liquidation cascades, oracle manipulation, and
  other adversarial patterns on public blockchains may result in losses.**
- **The bridge may be targeted by exploits, governance attacks, social
  engineering, or denial-of-service campaigns.**

### 5.7 Third-party dependencies

- **This repository references third-party software, Docker images, RPC
  endpoints, block explorers, and front-end components that are controlled by
  parties unrelated to this repository.** Their behavior, availability, and
  integrity are outside the control of the authors and of any operator.
- **Any third-party services (including but not limited to wallet extensions,
  RPC providers, chain explorers, indexers, and monitoring tools) may change
  their terms, pricing, or behavior at any time and without notice.**

## 6. No Investment or Financial Advice

Nothing in this repository is a recommendation to buy, sell, hold, or
interact with any asset. Discussions of economic design, liquidity, or token
mechanics are **technical descriptions of how the software functions** — not
suggestions that you should use them or take any action. wL1 is a technical
wrapper for cross-chain transfer, described for engineering purposes only.

## 7. Forward-Looking Statements

Documentation may describe planned features, future configurations, or
roadmap items. **These are not promises or commitments.** They may be
delayed, changed, or abandoned at any time without notice. Do not make
decisions based on them.

## 8. Privacy and Data

The software in this repository does not collect personal information.
However, **all interaction with public blockchains is pseudonymous but not
anonymous.** Transactions, addresses, and balances are permanently and
publicly visible. Running validator or relayer infrastructure may expose your
IP address, server hostname, or identifying metadata to the public internet.

## 9. Modifications and Forks

You may modify, fork, or redistribute this software under the terms of the
[MIT License](LICENSE). **Modified versions are the sole responsibility of
whoever distributes them.** The original authors have no control over, and no
responsibility for, forked or modified versions.

## 10. No Obligation to Maintain

**The authors, contributors, and operators have no obligation to maintain,
update, patch, support, run, or respond to issues or pull requests.**
Security vulnerabilities may not be fixed. Validators and relayers may shut
down at any time. The project may be abandoned at any time.

---

## Acceptance

**BY USING ANY PART OF THIS REPOSITORY, OR BY RELYING ON ANY VALIDATOR OR
RELAYER THAT RUNS IT, YOU AGREE THAT:**

1. **YOU HAVE READ, UNDERSTOOD, AND ACCEPT THIS ENTIRE DISCLAIMER.**
2. **THIS IS AN EXPERIMENT, AND YOU ACCEPT ALL RISKS DESCRIBED AND
   UNDESCRIBED, INCLUDING THE TOTAL LOSS OF ANYTHING YOU PUT THROUGH IT.**
3. **YOU WILL NOT HOLD THE AUTHORS, CONTRIBUTORS, OR ANY VALIDATOR OR RELAYER
   OPERATOR LIABLE FOR ANY LOSS OR DAMAGE.**
4. **YOU UNDERSTAND THAT VALIDATORS AND RELAYERS ARE NEUTRAL, NON-CUSTODIAL
   INFRASTRUCTURE THAT DO NOT CONTROL YOUR FUNDS AND ARE NOT YOUR
   COUNTERPARTY.**
5. **IF YOU DO NOT AGREE WITH ANY PART OF THIS DISCLAIMER, YOU MUST NOT USE
   THIS SOFTWARE OR RELY ON ANY INFRASTRUCTURE THAT RUNS IT.**

---

*This disclaimer is effective as of the date you access this repository and
applies to all past and future interactions with it and any contracts,
infrastructure, or services it describes.*
