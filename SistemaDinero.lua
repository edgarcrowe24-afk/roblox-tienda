-- ====================================
-- SISTEMA DE DINERO DEL JUEGO
-- ====================================

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerGameData")

-- Tabla para almacenar datos de jugadores
local playerData = {}

-- Función para cargar datos del jugador
local function cargarDatosJugador(player)
	local success, data = pcall(function()
		return playerDataStore:GetAsync(player.UserId)
	end)
	
	if success and data then
		playerData[player.UserId] = data
	else
		playerData[player.UserId] = {
			dinero = 0,  -- Dinero del juego (pesos)
			robux = 0,   -- Robux comprados
			velocidad = 1,  -- Multiplicador de velocidad
			salto = 1,      -- Multiplicador de salto
			compras = {}
		}
	end
	
	print("✓ Datos cargados para " .. player.Name .. " | Dinero: " .. playerData[player.UserId].dinero)
end

-- Función para guardar datos del jugador
local function guardarDatosJugador(player)
	local success = pcall(function()
		playerDataStore:SetAsync(player.UserId, playerData[player.UserId])
	end)
	
	if success then
		print("✓ Datos guardados para " .. player.Name)
	end
end

-- Función para agregar dinero
local function agregarDinero(player, cantidad)
	if not playerData[player.UserId] then return end
	playerData[player.UserId].dinero = playerData[player.UserId].dinero + cantidad
	guardarDatosJugador(player)
	return playerData[player.UserId].dinero
end

-- Función para restar dinero
local function restarDinero(player, cantidad)
	if not playerData[player.UserId] then return false end
	if playerData[player.UserId].dinero < cantidad then
		return false
	end
	playerData[player.UserId].dinero = playerData[player.UserId].dinero - cantidad
	guardarDatosJugador(player)
	return true
end

-- Función para obtener dinero
local function obtenerDinero(player)
	return playerData[player.UserId].dinero or 0
end

-- Función para comprar Robux
local function comprarRobux(player, cantidad, precioEnPesos)
	if restarDinero(player, precioEnPesos) then
		playerData[player.UserId].robux = playerData[player.UserId].robux + cantidad
		table.insert(playerData[player.UserId].compras, {
			tipo = "robux",
			cantidad = cantidad,
			precio = precioEnPesos,
			fecha = os.time()
		})
		guardarDatosJugador(player)
		return true, "¡Compra exitosa! +" .. cantidad .. " Robux"
	else
		return false, "No tienes suficiente dinero"
	end
end

-- Función para obtener Robux
local function obtenerRobux(player)
	return playerData[player.UserId].robux or 0
end

-- Función para comprar mejora
local function comprarMejora(player, tipo, precio)
	if restarDinero(player, precio) then
		if tipo == "velocidad" then
			playerData[player.UserId].velocidad = playerData[player.UserId].velocidad + 0.5
		elseif tipo == "salto" then
			playerData[player.UserId].salto = playerData[player.UserId].salto + 0.5
		end
		table.insert(playerData[player.UserId].compras, {
			tipo = tipo,
			precio = precio,
			fecha = os.time()
		})
		guardarDatosJugador(player)
		return true
	else
		return false
	end
end

-- Función para obtener mejoras
local function obtenerMejoras(player)
	return {
		velocidad = playerData[player.UserId].velocidad or 1,
		salto = playerData[player.UserId].salto or 1
	}
end

-- Eventos cuando un jugador entra
Players.PlayerAdded:Connect(function(player)
	cargarDatosJugador(player)
	-- Agregar dinero inicial de prueba
	agregarDinero(player, 50000)
end)

-- Eventos cuando un jugador sale
Players.PlayerRemoving:Connect(function(player)
	guardarDatosJugador(player)
	playerData[player.UserId] = nil
end)

-- Exportar funciones globales
_G.Dinero = {
	agregar = agregarDinero,
	restar = restarDinero,
	obtener = obtenerDinero,
	comprarRobux = comprarRobux,
	obtenerRobux = obtenerRobux,
	comprarMejora = comprarMejora,
	obtenerMejoras = obtenerMejoras,
	playerData = playerData
}

print("✓ Sistema de dinero iniciado")
