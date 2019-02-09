#tag Class
Protected Class ModelSomethingToLicense
Implements WooCommerceLicense.WCLInterface
	#tag Method, Flags = &h0
		Sub wclErrorMessage(error as Text)
		  // Part of the WooCommerceLicense.WCLInterface interface.
		  
		  MsgBox error
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub wcLicenseCheck(Active as Boolean = false)
		  // Part of the WooCommerceLicense.WCLInterface interface.
		  
		  if Active then
		    MsgBox "license active"
		  else
		    MsgBox "license non active"
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Licenses() As WooCommerceLicense.WPLicense
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
