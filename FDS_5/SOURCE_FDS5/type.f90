MODULE TYPES

! Definitions of various derived data types
 
USE PRECISION_PARAMETERS
USE GLOBAL_CONSTANTS

IMPLICIT NONE
CHARACTER(255), PARAMETER ::typeid='$Id$'

TYPE PARTICLE_CLASS_TYPE
   CHARACTER(30) :: CLASS_NAME,SPECIES,QUANTITIES(10)
   REAL(EB) :: DENSITY,H_V,C_P,TMP_V,TMP_MELT,FTPR,MASS_PER_VOLUME, &
               HEAT_OF_COMBUSTION,ADJUST_EVAPORATION, &
               LIFETIME,DIAMETER,MINIMUM_DIAMETER,MAXIMUM_DIAMETER,GAMMA, &
               TMP_INITIAL,SIGMA,X1,X2,Y1,Y2,Z1,Z2,DT_INSERT,GAMMA_VAP,&
               VERTICAL_VELOCITY,HORIZONTAL_VELOCITY
   REAL(EB), POINTER, DIMENSION(:) :: R_CDF,CDF,W_CDF,INSERT_CLOCK,KWR
   REAL(EB), POINTER, DIMENSION(:,:) :: WQABS,WQSCA
   INTEGER :: N_INITIAL,SAMPLING,N_INSERT,SPECIES_INDEX,N_QUANTITIES,QUANTITIES_INDEX(10),EVAP_INDEX=0,RGB(3)
   INTEGER,  POINTER, DIMENSION(:) :: IL_CDF,IU_CDF
   LOGICAL :: STATIC,WATER,FUEL,MASSLESS,TREE,MONODISPERSE
END TYPE PARTICLE_CLASS_TYPE

TYPE (PARTICLE_CLASS_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: PARTICLE_CLASS

TYPE DROPLET_TYPE
   REAL(EB) :: X,Y,Z,TMP,U,V,W,R,PWT,A_X,A_Y,A_Z,T,RE=0._EB
   INTEGER  :: IOR,CLASS,TAG,WALL_INDEX=0
   LOGICAL  :: SHOW
END TYPE DROPLET_TYPE

TYPE WALL_TYPE
   REAL(EB), POINTER, DIMENSION(:) :: TMP_S, LAYER_THICKNESS,X_S
   REAL(EB), POINTER, DIMENSION(:,:) :: ILW,RHO_S
   INTEGER, POINTER, DIMENSION(:) :: N_LAYER_CELLS
   LOGICAL :: SHRINKING, BURNAWAY
END TYPE WALL_TYPE
 
TYPE SPECIES_TYPE
   REAL(EB), DIMENSION(0:500) :: MU,K,D,CP,H_G,RCP
   REAL(EB) :: MW,YY0,RCON,MAXMASS
   REAL(EB), DIMENSION(0:10000) :: MW_MF,RSUM_MF,Z_MAX
   REAL(EB), DIMENSION(0:10000,1:9) :: Y_MF
   REAL(EB), DIMENSION(0:100,0:500) :: CP_MF,RCP_MF,MU_MF,K_MF,D_MF
   LOGICAL :: ABSORBING
   REAL(EB), POINTER, DIMENSION(:,:,:) :: KAPPA
   CHARACTER(30):: NAME
   INTEGER :: NKAP_MASS,NKAP_TEMP,MODE,REAC_INDEX
END TYPE SPECIES_TYPE

TYPE (SPECIES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SPECIES

TYPE REACTION_TYPE
   CHARACTER(30) :: FUEL,OXIDIZER,NAME
   INTEGER :: I_FUEL=0,I_OXIDIZER=0,MODE
   REAL(EB) :: EPUMO2,HEAT_OF_COMBUSTION,BOF,E, &
      NU_N2,NU_O2,NU_SOOT,NU_CO,NU_H2,NU_CO2,NU_H2O,N_F=0,N_O=0, &
      Y_O2_INFTY,Y_N2_INLET=0,Y_N2_INFTY=0,Y_F_INLET,MW_FUEL,NU_OTHER,MW_OTHER, &
      CO_YIELD,SOOT_YIELD,H2_YIELD, SOOT_H_FRACTION, &
      CRIT_FLAME_TMP,Y_F_LFL,Y_O2_LL,O2_F_RATIO=0,Z_F=0,Z_F_CONS=0
   REAL(EB), DIMENSION(1:20) :: NU=0,N=0
   LOGICAL :: SLOW,IDEAL
END TYPE REACTION_TYPE

TYPE (REACTION_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: REACTION
 
TYPE MATERIAL_TYPE
   REAL(EB) :: K_S,C_S,HEAT_OF_COMBUSTION,RHO_S,EMISSIVITY,DIFFUSIVITY,KAPPA_S,MOISTURE_FRACTION, &
               ADJUST_BURN_RATE
   INTEGER :: PYROLYSIS_MODEL
   CHARACTER(30) :: RAMP_K_S,RAMP_C_S
   INTEGER :: N_REACTIONS
   REAL(EB), DIMENSION(1:MAX_REACTIONS) :: NU_RESIDUE,NU_FUEL,NU_WATER,A,E,H_R,N_S,N_T
   REAL(EB), DIMENSION(1:MAX_REACTIONS) :: TMP_REF,TMP_IGN,TMP_BOIL
   REAL(EB), POINTER, DIMENSION(:,:) :: Q_ARRAY
   INTEGER, DIMENSION(1:MAX_REACTIONS) :: RESIDUE_MATL_INDEX
   CHARACTER(30), DIMENSION(1:MAX_REACTIONS) :: RESIDUE_MATL_NAME
END TYPE MATERIAL_TYPE

TYPE (MATERIAL_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: MATERIAL

TYPE SURFACE_TYPE
   REAL(EB) :: SLIP_FACTOR,TMP_FRONT,TMP_INNER,VEL,PLE,Z0,CONVECTIVE_HEAT_FLUX, &
               VOLUME_FLUX,HRRPUA,MLRPUA,T_IGN,SURFACE_DENSITY,CELL_SIZE_FACTOR, &
               E_COEFFICIENT,TEXTURE_WIDTH,TEXTURE_HEIGHT,THICKNESS,EXTERNAL_FLUX,TMP_BACK, &
               DXF,DXB,MASS_FLUX_TOTAL,STRETCH_FACTOR,PARTICLE_MASS_FLUX,EMISSIVITY,MAX_PRESSURE,&
               TMP_IGN,H_V
   REAL(EB), POINTER, DIMENSION(:) :: DX,RDX,RDXN,X_S,DX_WGT
   REAL(EB), DIMENSION(0:20) :: MASS_FRACTION,MASS_FLUX
   REAL(EB), DIMENSION(-3:20) :: TAU
   INTEGER,  DIMENSION(-3:20) :: RAMP_INDEX=0
   INTEGER, DIMENSION(3) :: RGB
   REAL(EB) :: TRANSPARENCY
   REAL(EB), DIMENSION(2) :: VEL_T
   INTEGER, DIMENSION(2) :: LEAK_PATH,DUCT_PATH
   INTEGER :: THERMAL_BC_INDEX,NPPC,SPECIES_BC_INDEX,SURF_TYPE,N_CELLS,PART_INDEX
   INTEGER :: PYROLYSIS_MODEL
   INTEGER :: N_LAYERS,N_MATL
   INTEGER, POINTER, DIMENSION(:) :: N_LAYER_CELLS,LAYER_INDEX,MATL_INDEX
   INTEGER, DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_INDEX
   INTEGER, DIMENSION(MAX_LAYERS) :: N_LAYER_MATL
   INTEGER, POINTER, DIMENSION(:,:) :: RESIDUE_INDEX
   REAL(EB), POINTER, DIMENSION(:) :: MIN_DIFFUSIVITY
   REAL(EB), DIMENSION(MAX_LAYERS) :: LAYER_THICKNESS, LAYER_DENSITY
   CHARACTER(30), POINTER, DIMENSION(:) :: MATL_NAME
   CHARACTER(30), DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_NAME
   REAL(EB), DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_FRAC
   LOGICAL :: BURN_AWAY,ADIABATIC,THERMALLY_THICK,INTERNAL_RADIATION,SHRINK,POROUS=.FALSE.
   INTEGER :: GEOMETRY,BACKING,PROFILE
   CHARACTER(30) :: PART_ID,RAMP_Q,RAMP_V,RAMP_T
   CHARACTER(30), DIMENSION(0:20) :: RAMP_MF
   CHARACTER(60) :: TEXTURE_MAP
END TYPE SURFACE_TYPE

TYPE (SURFACE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SURFACE

TYPE OMESH_TYPE
   REAL(EB), POINTER, DIMENSION(:,:,:) :: TMP,U,V,W,H,FVX,FVY,FVZ
   REAL(EB), POINTER, DIMENSION(:,:,:,:) :: YY,YYS
   REAL(EB), POINTER, DIMENSION(:) :: RPKG1,RPKG2,RPKG3, &
                       SPKG1,SPKG2,SPKG3,WSPKG,WRPKG
   INTEGER, POINTER, DIMENSION(:,:) :: IJKW
   INTEGER, POINTER, DIMENSION(:) :: BOUNDARY_TYPE
   TYPE(WALL_TYPE), POINTER, DIMENSION(:) :: WALL
   TYPE(DROPLET_TYPE), POINTER, DIMENSION(:) :: DROPLET
   INTEGER :: N_DROP_ORPHANS,N_DROP_ORPHANS_DIM,N_DROP_ADOPT
   REAL(EB), POINTER, DIMENSION(:) :: R_RDBUF,S_RDBUF
   INTEGER , POINTER, DIMENSION(:) :: R_IDBUF,S_IDBUF
   LOGICAL , POINTER, DIMENSION(:) :: R_LDBUF,S_LDBUF
END TYPE OMESH_TYPE
 
TYPE OBSTRUCTION_TYPE
   INTEGER :: I1=-1,I2=-1,J1=-1,J2=-1,K1=-1,K2=-1,BCI=-1,BTI=-1,ORDINAL=0,DEVC_INDEX=-1,CTRL_INDEX=-1
   CHARACTER(30) :: DEVC_ID='null',CTRL_ID='null'
   INTEGER, DIMENSION(3) :: RGB=(/0,0,0/)
   REAL(EB) :: TRANSPARENCY = 1._EB
   REAL(EB), DIMENSION(3) :: TEXTURE=0._EB
   INTEGER, DIMENSION(-3:3) :: IBC=0
   INTEGER, DIMENSION(3) :: DIMENSIONS=0
   REAL(EB) :: X1=0._EB,X2=1._EB,Y1=0._EB,Y2=1._EB,Z1=0._EB,Z2=1._EB,T_REMOVE=1.E6_EB,MASS=1.E6_EB
   REAL(EB), DIMENSION(3) :: FDS_AREA=-1._EB,INPUT_AREA=-1._EB
   LOGICAL, DIMENSION(-3:3) :: SHOW_BNDF=.TRUE.
   LOGICAL :: SAWTOOTH=.TRUE.,HIDDEN=.FALSE.,PERMIT_HOLE=.TRUE.,ALLOW_VENT=.TRUE.,CONSUMABLE=.FALSE.,REMOVABLE=.FALSE., &
              THIN=.FALSE.
END TYPE OBSTRUCTION_TYPE
 
TYPE VENTS_TYPE
   INTEGER :: I1=-1,I2=-1,J1=-1,J2=-1,K1=-1,K2=-1,BOUNDARY_TYPE=0,IOR=0,IBC=0,DEVC_INDEX=-1,CTRL_INDEX=-1,VCI=99,VTI=0,ORDINAL=0
   INTEGER, DIMENSION(3) :: RGB=-1
   REAL(EB) :: TRANSPARENCY = 1._EB
   REAL(EB), DIMENSION(3) :: TEXTURE=0._EB
   REAL(EB) :: X1=0._EB,X2=0._EB,Y1=0._EB,Y2=0._EB,Z1=0._EB,Z2=0._EB,FDS_AREA=0._EB,TOTAL_INPUT_AREA=0._EB, &
                X0=-999._EB,Y0=-999._EB,Z0=-999._EB,FIRE_SPREAD_RATE=0.05_EB,INPUT_AREA=0._EB
   LOGICAL :: ACTIVATED=.TRUE.
   CHARACTER(30) :: DEVC_ID='null',CTRL_ID='null'
END TYPE VENTS_TYPE
 
TYPE TABLES_TYPE
   INTEGER :: NUMBER_ROWS,NUMBER_COLUMNS
   REAL(EB), POINTER, DIMENSION (:,:) :: TABLE_DATA
END TYPE TABLES_TYPE

TYPE (TABLES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: TABLES
   
TYPE RAMPS_TYPE
   REAL(EB) :: SPAN,DT,T_MIN,T_MAX,VALUE
   REAL(EB), POINTER, DIMENSION(:) :: INDEPENDENT_DATA,DEPENDENT_DATA,INTERPOLATED_DATA
   INTEGER :: NUMBER_DATA_POINTS,NUMBER_INTERPOLATION_POINTS,DEVC_INDEX=-1,CTRL_INDEX=-1
   CHARACTER(30) :: DEVC_ID='null',CTRL_ID='null'
END TYPE RAMPS_TYPE

TYPE (RAMPS_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: RAMPS

TYPE HUMAN_TYPE
   CHARACTER(60) :: NODE_NAME
   CHARACTER(30) :: FFIELD_NAME
   REAL(EB) :: X,Y,Z,U,V,W,F_X,F_Y,X_old,Y_old,X_group,Y_group
   REAL(EB) :: U_Center, V_Center, UBAR_Center, VBAR_Center
   REAL(EB) :: Speed, Radius, Mass, Tpre, Tau, Eta, Ksi, Tdet
   REAL(EB) :: r_torso, r_shoulder, d_shoulder, angle, torque, m_iner
   REAL(EB) :: tau_iner, angle_old, omega
   REAL(EB) :: A, B, C_Young, Gamma, Kappa, Lambda, Commitment
   REAL(EB) :: SumForces, IntDose, DoseCrit1, DoseCrit2, SumForces2
   REAL(EB) :: TempMax1, FluxMax1, TempMax2, FluxMax2
   REAL(EB) :: P_detect_tot, v0_fac
   INTEGER  :: IOR, ILABEL, COLOR_INDEX, INODE, IMESH, IPC, IEL, I_FFIELD
   INTEGER  :: GROUP_ID, DETECT1, GROUP_SIZE, I_Target
   LOGICAL  :: SHOW, NewRnd
END TYPE HUMAN_TYPE

TYPE HUMAN_GRID_TYPE
! (x,y,z) Centers of the grid cells in the main evacuation meshes
! SOOT_DENS: Smoke density at the center of the cell (mg/m3)
! FED_CO_CO2_O2: Purser's FED for co, co2, and o2
   REAL(EB) :: X,Y,Z,SOOT_DENS,FED_CO_CO2_O2,TMP_G,RADINT
   INTEGER :: N, N_old, IGRID, IHUMAN, ILABEL
! IMESH: (x,y,z) which fire mesh, if any
! II,JJ,KK: Fire mesh cell reference
   INTEGER  :: IMESH,II,JJ,KK
END TYPE HUMAN_GRID_TYPE
 
TYPE OUTPUT_QUANTITY_TYPE
   CHARACTER(30) :: NAME='null',SHORT_NAME='null',UNITS='null'
   REAL(EB) :: AMBIENT_VALUE=0._EB
   INTEGER :: IOR=0,CELL_POSITION=1
   LOGICAL :: SLCF_APPROPRIATE=.TRUE., BNDF_APPROPRIATE=.FALSE., ISOF_APPROPRIATE=.TRUE., PART_APPROPRIATE=.FALSE., &
              MIXTURE_FRACTION_ONLY=.FALSE.,INTEGRATED=.FALSE.,SOLID_PHASE=.FALSE.,GAS_PHASE=.TRUE.,INTEGRATED_DROPLETS=.FALSE.
END TYPE OUTPUT_QUANTITY_TYPE

TYPE (OUTPUT_QUANTITY_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: OUTPUT_QUANTITY

TYPE SLICE_TYPE
   INTEGER :: I1,I2,J1,J2,K1,K2,INDEX
   LOGICAL :: RLE
   REAL(FB), DIMENSION(2) :: MINMAX
   LOGICAL :: TWO_BYTE
END TYPE SLICE_TYPE

TYPE BOUNDARY_FILE_TYPE
   INTEGER :: INDEX,PROP_INDEX
END TYPE BOUNDARY_FILE_TYPE

TYPE (BOUNDARY_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: BOUNDARY_FILE

TYPE ISOSURFACE_FILE_TYPE
   INTEGER :: INDEX=1,INDEX2=0,REDUCE_TRIANGLES=1,N_VALUES=1
   REAL(FB) :: VALUE(10)
END TYPE ISOSURFACE_FILE_TYPE

TYPE (ISOSURFACE_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: ISOSURFACE_FILE

TYPE PROFILE_TYPE
   REAL(EB) :: X,Y,Z
   INTEGER  :: IOR,IW,ORDINAL,MESH
   CHARACTER(30) :: ID,QUANTITY
END TYPE PROFILE_TYPE

TYPE (PROFILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: PROFILE

TYPE INITIALIZATION_TYPE
   REAL(EB) :: TEMPERATURE,DENSITY,MASS_FRACTION(20),X1,X2,Y1,Y2,Z1,Z2
   LOGICAL :: ADJUST_DENSITY=.FALSE., ADJUST_TEMPERATURE=.FALSE.
END TYPE INITIALIZATION_TYPE

TYPE (INITIALIZATION_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: INITIALIZATION

TYPE P_ZONE_TYPE
   REAL(EB) :: X1,X2,Y1,Y2,Z1,Z2
   REAL(EB), DIMENSION(0:20) :: LEAK_AREA
   CHARACTER(30) :: ID
END TYPE P_ZONE_TYPE

TYPE (P_ZONE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: P_ZONE

END MODULE TYPES
 
