-- PlanetGoldInvariants.agda
-- Cross-body gold accessibility comparison:
-- Earth (Terrestrial) vs 16 Psyche (Stripped Core) vs Jupiter (Gas Giant)
-- Author: Ahmad Ali Parr

{-# OPTIONS --safe --without-K #-}
module PlanetGoldInvariants where

open import Data.Nat using (ℕ; _+_; _≤_)
open import Data.Product using (_×_; _,_)

-- ============================================================
-- STRUCTURAL ARCHETYPES
-- ============================================================

data BodyType : Set where
  Terrestrial  : BodyType   -- Differentiated intact planet (Earth, ~99% core-locked)
  StrippedCore : BodyType   -- Exposed planetary core (16 Psyche, ~100% accessible)
  GasGiant     : BodyType   -- Fluid envelope (Jupiter, ~0% accessible)

-- ============================================================
-- PLANETARY BODY PROFILE
-- ============================================================

record BodyProfile : Set where
  field
    totalMass   : ℕ
    coreGold    : ℕ
    mantleGold  : ℕ
    surfaceGold : ℕ
    archetype   : BodyType

-- ============================================================
-- INVARIANT 1: TOTAL GOLD MASS CONSERVATION
-- ============================================================

totalGold : BodyProfile → ℕ
totalGold b = BodyProfile.coreGold b + BodyProfile.mantleGold b + BodyProfile.surfaceGold b

-- ============================================================
-- INVARIANT 2: MASS BOUNDS
-- Gold cannot exceed total planetary mass
-- ============================================================

record MassBounded (b : BodyProfile) : Set where
  field
    massBound : totalGold b ≤ BodyProfile.totalMass b

-- ============================================================
-- INVARIANT 3: ACCESSIBILITY MAPPING
-- Access determined by structural envelope:
--   Terrestrial  → surface gold only (crust/upper mantle)
--   StrippedCore → full gold accessible (no mantle cap)
--   GasGiant     → zero accessible (fluid envelope traps all gold)
-- ============================================================

accessibleGold : BodyProfile → ℕ
accessibleGold b with BodyProfile.archetype b
... | Terrestrial  = BodyProfile.surfaceGold b
... | StrippedCore = totalGold b
... | GasGiant     = 0

-- ============================================================
-- INVARIANT 4: SIDEROPHILE CORE SEQUESTRATION
-- In intact rocky bodies, core gold dominates non-core gold
-- Result of iron catastrophe / planetary differentiation
-- ============================================================

record SiderophileSequestration (b : BodyProfile) : Set where
  field
    coreDominated : (BodyProfile.mantleGold b + BodyProfile.surfaceGold b)
                    ≤ BodyProfile.coreGold b

-- ============================================================
-- CROSS-COMPARISON THEOREM STRUCTURE
-- Earth vs 16 Psyche vs Jupiter
-- ============================================================

record CrossComparison (earth psyche jupiter : BodyProfile) : Set where
  field
    -- Absolute Quantity: Jupiter's bulk mass exceeds rocky bodies
    jupiterAbsoluteMax : totalGold earth ≤ totalGold jupiter

    -- Core Reservoir: Earth's differentiated core exceeds small protoplanets
    earthCoreMax       : BodyProfile.coreGold psyche ≤ BodyProfile.coreGold earth

    -- Accessibility: Stripped protoplanet core maximizes accessible yield
    -- 16 Psyche accessible ≥ Earth accessible (surface-only vs full core)
    psycheAccessMax    : accessibleGold earth ≤ accessibleGold psyche
