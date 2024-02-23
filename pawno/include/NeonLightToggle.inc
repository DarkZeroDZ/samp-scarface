#include <a_samp>

new	NeonObject[ MAX_VEHICLES ][ 2 ];

stock ToggleVehicleNeon( vehicleid, neonid, bool: mode )
{
	// Function: ToggleVehicleNeon( vehicleid, neonid, bool: mode
	// Will add selected neon on vehicle.
	switch( mode )
	{
	    case true:
	    {
			switch( neonid )
			{
			    case 0:
			    {
			        NeonObject[ vehicleid ][ 0 ] = CreateObject( 18647, 0, 0, 0, 0, 0, 0 );
			        NeonObject[ vehicleid ][ 1 ] = CreateObject( 18647, 0, 0, 0, 0, 0, 0 );
				}
				case 1:
				{
				    NeonObject[ vehicleid ][ 0 ] = CreateObject( 18648, 0, 0, 0, 0, 0, 0 );
				    NeonObject[ vehicleid ][ 1 ] = CreateObject( 18648, 0, 0, 0, 0, 0, 0 );
				}
				case 2:
				{
				    NeonObject[ vehicleid ][ 0 ] = CreateObject( 18649, 0, 0, 0, 0, 0, 0 );
				    NeonObject[ vehicleid ][ 1 ] = CreateObject( 18649, 0, 0, 0, 0, 0, 0 );
				}
				case 3:
				{
				    NeonObject[ vehicleid ][ 0 ] = CreateObject( 18650, 0, 0, 0, 0, 0, 0 );
				    NeonObject[ vehicleid ][ 1 ] = CreateObject( 18650, 0, 0, 0, 0, 0, 0 );
				}
				case 4:
				{
				    NeonObject[ vehicleid ][ 0 ] = CreateObject( 18651, 0, 0, 0, 0, 0, 0 );
				    NeonObject[ vehicleid ][ 1 ] = CreateObject( 18651, 0, 0, 0, 0, 0, 0 );
				}
				case 5:
				{
				    NeonObject[ vehicleid ][ 0 ] = CreateObject( 18652, 0, 0, 0, 0, 0, 0 );
                    NeonObject[ vehicleid ][ 1 ] = CreateObject( 18652, 0, 0, 0, 0, 0, 0 );
				}
			}
   			AttachObjectToVehicle( NeonObject[ vehicleid ][ 0 ], vehicleid, 0.94, 0, -0.48, 0, 0, 0 );
   			AttachObjectToVehicle( NeonObject[ vehicleid ][ 1 ], vehicleid, -0.94, 0, -0.48, 0, 0, 0 );
			}
			case false:
			{
 				DestroyObject( NeonObject[ vehicleid ][ 0 ] );
 				DestroyObject( NeonObject[ vehicleid ][ 1 ] );
			}
		}
	return true;
}