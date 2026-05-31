-- ====================================
-- CREADOR DE PLATAFORMA CON BRAINROTS
-- ====================================

local function crearPlataforma()
	-- Crear base/plataforma
	local base = Instance.new("Part")
	base.Name = "PlataformaBrainrot"
	base.Shape = Enum.PartType.Block
	base.Size = Vector3.new(50, 1, 50)
	base.BrickColor = BrickColor.new("Dark stone grey")
	base.Material = Enum.Material.Concrete
	base.CanCollide = true
	base.CFrame = CFrame.new(0, 5, 0)
	base.Parent = workspace
	
	print("✓ Plataforma creada")
end

local function crearBrainrot(nombre, valor, posicion)
	-- Crear el Brainrot (parte)
	local brainrot = Instance.new("Part")
	brainrot.Name = "Brainrot_" .. valor
	brainrot.Shape = Enum.PartType.Ball
	brainrot.Size = Vector3.new(2, 2, 2)
	brainrot.BrickColor = BrickColor.new("Magenta")
	brainrot.Material = Enum.Material.Neon
	brainrot.CanCollide = true
	brainrot.CFrame = CFrame.new(posicion)
	brainrot.Parent = workspace
	
	-- Etiqueta con el valor
	local label = Instance.new("TextLabel")
	label.Name = "ValorLabel"
	label.Size = UDim2.new(2, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.Text = "+" .. valor
	label.Parent = brainrot
	
	-- Detector de toque
	local touched = false
	brainrot.Touched:Connect(function(hit)
		if touched then return end
		
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			touched = true
			
			-- Obtener el jugador
			local player = game:GetService("Players"):FindFirstChild(hit.Parent.Name)
			if player then
				-- Agregar dinero
				if _G.Dinero then
					_G.Dinero.agregar(player, valor)
					print("✓ " .. player.Name .. " ganó " .. valor .. " pesos")
				end
			end
			
			-- Mostrar efecto
			brainrot.BrickColor = BrickColor.new("Lime green")
			wait(0.3)
			
			-- Desaparecer
			brainrot:Destroy()
		end
	end)
	
	print("✓ Brainrot +" .. valor .. " creado en " .. tostring(posicion))
end

-- Crear plataforma
crearPlataforma()

-- Crear los 5 Brainrots
local posiciones = {
	Vector3.new(-15, 7, 0),
	Vector3.new(-7, 7, 0),
	Vector3.new(0, 7, 0),
	Vector3.new(7, 7, 0),
	Vector3.new(15, 7, 0)
}

local valores = {1, 2, 3, 4, 5}

for i, valor in ipairs(valores) do
	crearBrainrot("Brainrot_" .. valor, valor, posiciones[i])
	wait(0.2)
end

print("✓ Sistema de Brainrots cargado")
