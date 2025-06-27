#tag Class
Protected Class WPLicenseSocket
Inherits URLConnection
	#tag Event
		Sub ContentReceived(URL As String, HTTPStatus As Integer, content As String)
		  wpLicenseClass.Received(url, HTTPStatus, content)
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error(e As RuntimeException)
		  Try
		    wpLicenseClass.error = e.Message
		    wpSocketInterface.wclErrorMessage(wpLicenseClass)
		    
		  Catch re As RuntimeException
		    
		    System.DebugLog re.Message
		  End Try
		  ' MessageBox err.Message + err.Reason
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(wpInterface as WCLInterface)
		  wpSocketInterface = wpInterface
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(pWClass as WooCommerceLicense.WPLicense)
		  wpLicenseClass = pWClass
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		wpLicenseClass As WPLicense
	#tag EndProperty

	#tag Property, Flags = &h0
		wpSocketInterface As WooCommerceLicense.WCLInterface
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="FollowRedirects"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowCertificateValidation"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTTPStatusCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
