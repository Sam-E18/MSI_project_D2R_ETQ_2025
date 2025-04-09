#### Atoms selected for force application

# Read precomputed atom indices from file
set input [open "indices.txt" r]
gets $input indices
close $input

# Extract ligand and protein indices
set ligand_index [lindex $indices 0]
set protein_index [lindex $indices 1]

# Store in ligand group
set ligand_grp {}
lappend ligand_grp $ligand_index
set ligand_id [addgroup $ligand_grp]

# Store in protein group
set protein_grp {}
lappend protein_grp $protein_index
set protein_id [addgroup $protein_grp]

# Set the output frequency and initialize the time counter
set Tclfreq 50
set t 0

# Force parameters
set k 7.2         ;# Force constant in kcal/mol/Å²
set v 0.00002      ;# Pulling velocity in Å/timestep

# Output file
set outfilename da_smd_tcl.out
open $outfilename w

# Procedure to calculate and apply forces at each timestep
proc calcforces {} {
  global Tclfreq t k v ligand_id protein_id outfilename

  # Get current coordinates
  loadcoords coordinate

  # Get coordinates of the ligand group
  set r_lig $coordinate($ligand_id)
  set lx [lindex $r_lig 0]
  set ly [lindex $r_lig 1]
  set lz [lindex $r_lig 2]

  # Target: maintain X and Y as fixed, pull in +Z direction (upward)
  set f_lx 0.0
  set f_ly 0.0
  set f_lz [expr -1.0 * $k * ($v * $t)]

  # Apply force only to the ligand group
  set f_lig [list $f_lx $f_ly $f_lz]
  addforce $ligand_id $f_lig

  # Output data every Tclfreq timesteps
  set modval [expr $t % $Tclfreq]
  if { $modval == 0 } {
    set outfile [open $outfilename a]
    set time [expr $t * 2 / 1000.0] ;# convert to ps (2 fs per step)
    puts $outfile "$time $lz $f_lz"
    close $outfile
  }

  incr t
  return
}

