#tag Class
Protected Class WPLicense
	#tag Method, Flags = &h0
		Sub Activate()
		  Dim url as String = website+"/woocommerce/?wc-api=software-api&request=activation&email="+email+"&license_key="+license_key+"&product_id="+Product_id+"&platform="+Compagnie
		  if instance > 0 then url = url + "&instance="+instance.ToString
		  dim tURL as String = url.ReplaceAll(" ", "").ReplaceAll(chr(9), "").ReplaceAccents
		  
		  Dim SocketLicense as new WPLicenseSocket(me)
		  SocketLicense.Send("POST", tURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Check()
		  Dim url as String = website+"/woocommerce/?wc-api=software-api&request=check&email="+email+"&license_key="+license_key+"&product_id="+Product_id
		  
		  dim wpSocks as new WPLicenseSocket(me)
		  
		  dim tURL as String = url.ReplaceAll(" ", "").ReplaceAll(chr(9), "").ReplaceAccents
		  Try
		    wpSocks.Send("POST", tURL)
		    
		  catch err as UnsupportedOperationException
		    
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(pInterface as WCLInterface, dLicense as Dictionary)
		  // Calling the overridden superclass constructor.
		  wclInterface = pInterface
		  website = dLicense.Lookup("website", "https://exemple.com")
		  email = dLicense.Lookup("email", "")
		  instance = dLicense.Lookup("instance", 0)
		  license_key = dLicense.Lookup("license_key", "")
		  Product_id = dLicense.Lookup("Product_id", "")
		  dateAjout = dLicense.Lookup("dateAjout", DateTime.Now)
		  dateExpiration = dLicense.Lookup("dateExpiration", DateTime.Now)
		  Compagnie = dLicense.Lookup("Compagnie", "")
		  
		  if DateTime.Now.SecondsFrom1970 - dateAjout.SecondsFrom1970 > 2592000 or  DateTime.Now.SecondsFrom1970 - dateAjout.SecondsFrom1970 < 1 then
		    if email <> "" AND license_key <> "" AND Product_id <> "" then
		      Check
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConvertTextToJSON(Content as MemoryBlock) As Dictionary
		  'Dim jsonText as String = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content)
		  #Pragma BreakOnExceptions false
		  Try
		    dim sss as string = Content.StringValue(0, Content.Size)
		    #Pragma BreakOnExceptions true
		    return ParseJSON(Content)
		  Catch
		    #Pragma BreakOnExceptions true
		    Return new Dictionary
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Deactivation()
		  Dim url as String = website+"/woocommerce/?wc-api=software-api&request=deactivation&email="+email+"&license_key="+license_key+"&product_id="+Product_id+"&instance="+instance.ToText
		  
		  dim tURL as String = url.ReplaceAll(" ", "").ReplaceAll(Text.FromUnicodeCodepoint(0009), "").ReplaceAccents
		  Dim SocketLicense as new WPLicenseSocket(me)
		  
		  SocketLicense.Send("POST", tURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Received(url as string, HTTPStatus as integer, content as String)
		  Try
		    
		    'wclInterface.wclPageReceived(URL, HTTPStatus, Content)
		    dim d as Dictionary = ConvertTextToJSON(Content)
		    Active = d.Lookup("activated", false)
		    Success = d.Lookup("success", false)
		    Message = d.Lookup("message", "")
		    error = d.Lookup("error", "")
		    if  d.Lookup("instance", 0) > 0 then instance = d.Lookup("instance", 0)
		    
		    if d.HasKey("activations") then
		      Dim aActivations() as Variant = d.Value("activations")
		      if aActivations.Ubound > -1 then
		        for each item as Dictionary in aActivations
		          Activations.Append(item)
		          dim dInstance as Integer = Integer.FromString(item.Lookup("instance", "0"))
		          if dInstance = 0 then Continue
		          if instance = dInstance then
		            Active = true
		            exit
		          end if
		        Next
		      end if
		    end if
		    
		    if not Active then
		      if ActivationAttempt < 1 then
		        Timer.CallLater(10000, AddressOf Activate)
		        ActivationAttempt = ActivationAttempt + 1
		      else
		        wclInterface.wcLicenseCheck(me)
		      end if
		      
		    else
		      wclInterface.wcLicenseCheck(me)
		    end if
		    
		    
		    
		  Catch re As RuntimeException
		    
		    System.DebugLog re.Message
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ActivationAttempt As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Activations() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Active As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Compagnie As String
	#tag EndProperty

	#tag Property, Flags = &h0
		dateAjout As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		dateExpiration As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		email As String
	#tag EndProperty

	#tag Property, Flags = &h0
		error As String
	#tag EndProperty

	#tag Property, Flags = &h0
		instance As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		license_key As String = "NOKEY"
	#tag EndProperty

	#tag Property, Flags = &h0
		Message As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Product_id As String = "NOIDPRODUCT"
	#tag EndProperty

	#tag Property, Flags = &h0
		Success As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		wclInterface As WooCommerceLicense.WCLInterface
	#tag EndProperty

	#tag Property, Flags = &h0
		website As String
	#tag EndProperty

	#tag Property, Flags = &h0
		wpSocket As WPLicenseSocket
	#tag EndProperty


	#tag ViewBehavior
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
		#tag ViewProperty
			Name="website"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Success"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Product_id"
			Visible=false
			Group="Behavior"
			InitialValue="NOIDPRODUCT"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Message"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="license_key"
			Visible=false
			Group="Behavior"
			InitialValue="NOKEY"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="instance"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="error"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="email"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compagnie"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Active"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActivationAttempt"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
